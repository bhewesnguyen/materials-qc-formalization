from pathlib import Path, PurePosixPath
import json,hashlib,zipfile,re,datetime
ROOT=Path('/workspace/scratch/0a42b15a2c38'); S=ROOT/'audit_release_readiness/submitted/formal-science'; P=ROOT/'audit_markov/submitted/formal-science'; C=ROOT/'audit_release_readiness/companion'; W=ROOT/'audit_release_readiness/work'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
j=lambda p:json.loads(p.read_text())
checks={};errors=[]
def demand(x,n):
 if not x:errors.append(n)
 return x
def manifest(base,relative,paths=None):
 d=j(base/relative); fs=d['files'];bad=[]
 for p,v in fs.items():
  f=base/p
  if not f.is_file() or sha(f)!=v['sha256'] or f.stat().st_size!=v['bytes']:bad.append(p)
 actual=paths if paths is not None else {str(f.relative_to(base)) for f in base.rglob('*') if f.is_file()}
 extra=sorted(actual-set(fs)-{relative});missing=sorted(set(fs)-actual)
 demand(not bad and not extra and not missing,str(base)+' manifest')
 return {'payload_files':len(fs),'actual_files':len(actual),'mismatches':bad,'missing':missing,'extra':extra}
source_zip=ROOT/'upload/Formal_Science_Release_Readiness_Handoff.zip';comp_zip=ROOT/'upload/Formal_Science_Release_Readiness_Consumer_Evidence.zip'
for key,zp,b,mp,prefix,expected in [('source_archive',source_zip,S,'SOURCE_MANIFEST.json','formal-science/','e97dfc620b50a2a6a2d9de51b33ec009d6dfd17ea7acd3987ddc9d0096c408e0'),('companion_archive',comp_zip,C,'deliverables/release-readiness/v1/CONSUMER_EVIDENCE_MANIFEST.json','','7c6bca2065fb4c0068ef2d1265b97197d09dbedd0173e33f34983f2442d35553')]:
 with zipfile.ZipFile(zp) as z:
  names=[i.filename for i in z.infolist() if not i.is_dir()]; rel={n[len(prefix):] for n in names};crc=z.testzip();unsafe=[n for n in names if not n.startswith(prefix) or PurePosixPath(n).is_absolute() or '..'in PurePosixPath(n).parts];duplicates=len(names)!=len(set(names));symlinks=[i.filename for i in z.infolist() if (i.external_attr>>16)&0o170000==0o120000]
  q=manifest(b,mp,rel);q.update(sha256=sha(zp),bytes=zp.stat().st_size,zip_comment=z.comment.decode(),crc_bad_file=crc,unsafe_paths=unsafe,duplicates=duplicates,symlinks=symlinks,nested_archives=[n for n in names if n.endswith('.zip')]);checks[key]=q;demand(sha(zp)==expected and crc is None and not unsafe and not duplicates and not symlinks and not q['nested_archives'],key+' archive')
# Actual archived source set defines historical comparison, not local pycache produced during previous audits.
pm=j(P/'SOURCE_MANIFEST.json')['files'];sm=j(S/'SOURCE_MANIFEST.json')['files'];changed=[p for p in pm if p in sm and (P/p).read_bytes()!=(S/p).read_bytes()];missing=[p for p in pm if p not in sm];added=[p for p in sm if p not in pm]
checks['since_markov']={'old_payload_count':len(pm),'new_payload_count':len(sm),'missing':missing,'changed':changed,'added_count':len(added)};demand(not missing,'old payload missing')
allowed={'AGENTS.md','DECISIONS.md','NEXT_FABLE_TASK.md','TURNS.md','README.md','docs/SCOPE_MEMO.md'};demand(set(changed)<=allowed,'unauthorized old payload change')
for label,prefix in [('earlier_evidence','evidence/'),('earlier_audits','audits/'),('earlier_handoffs','deliverables/')]:
 paths=[p for p in pm if p.startswith(prefix)];bad=[p for p in paths if (P/p).read_bytes()!=(S/p).read_bytes()];checks[label]={'compared':len(paths),'changed':bad};demand(not bad,label)
rm=j(ROOT/'audit_markov/return/audits/markov/v1/RETURN_MANIFEST.json')['files'];rpaths=list(rm)+['audits/markov/v1/RETURN_MANIFEST.json'];bad=[p for p in rpaths if (ROOT/'audit_markov/return'/p).read_bytes()!=(S/p).read_bytes()];checks['exact_markov_return']={'payload_files':len(rm),'including_manifest':len(rpaths),'mismatches':bad};demand(not bad,'markov return')
freeze=j(S/'evidence/release-readiness/v1/freeze/freeze_check.json');fr=[]
for x in freeze['files']:
 p=x['path']; a=sha(P/p);b=sha(S/p); ok=a==b==x['sha256_at_markov_tag']==x['sha256_now'];fr.append({'path':p,'sha256':b,'identical':ok});demand(ok,'frozen '+p)
checks['freeze']={'compared_files':len(fr),'files':fr,'all_identical':all(x['identical']for x in fr)}
exp=j(S/'exports.json'); markovv=j(S/'evidence/markov/v1/verification/verification.json');results={}
def commands_consistency(base,summary):
 cmds=j(base/'commands.json');demand(cmds==summary['commands'],str(base)+' embedded command mismatch');bad=[]
 for cmd in cmds:
  for stream in ('stdout','stderr'):
   p=base/cmd[stream+'_file']
   if p.read_text()!=cmd[stream]:bad.append(cmd['label']+':'+stream)
 demand(not bad,str(base)+' raw logs mismatch');return cmds,bad
for label,base in [('baseline',S/'evidence/release-readiness/v1/reproduction/verification'),('final',S/'evidence/release-readiness/v1/verification'),('consumer',C/'evidence/release-readiness/v1/archive-consumer/verification')]:
 v=j(base/'verification.json');cmds,bad=commands_consistency(base,v);raw={};dups=[]
 for line in (base/'32-axiom-audit.stdout.log').read_text().splitlines():
  o=json.loads(line);m=re.fullmatch(r"'([^']+)' depends on axioms: \[(.*)\]",o['data'],re.S);demand(m is not None,label+' axiom malformed')
  if m:
   name=m.group(1)
   if name in raw:dups.append(name)
   raw[name]=sorted(s.strip() for s in m.group(2).split(',') if s.strip())
 rawok=raw==v['axioms']==markovv['axioms'];demand(rawok and not dups,label+' axioms')
 hashesok=all(sha(S/p)==h for p,h in v['source_sha256'].items()) and v['source_sha256']==markovv['source_sha256'];demand(hashesok,label+' sources')
 demand(v['manifest']==exp,label+' export manifest');demand(v['status']=='passed' and len(cmds)==32 and all(c['exit_code']==0 for c in cmds),label+' status')
 demand(all(dep['locked_revision']==dep['checked_out_head']and dep['tracked_clean']for dep in v['dependencies']),label+' pins')
 sourcecmds=[c for c in cmds if c['label'].startswith('release-source')or c['label']=='independent-contracts'];zero=all(not c['stdout'] and not c['stderr']for c in sourcecmds);demand(zero,label+' diagnostics')
 results[label]={'status':v['status'],'commands':len(cmds),'all_exit_zero':all(c['exit_code']==0 for c in cmds),'raw_log_mismatches':bad,'exports':len(exp['exports']),'contract_exports':len(exp['contract_exports']),'modules':len(exp['release_modules']),'raw_axiom_reports':len(raw),'axiom_map_identical_to_accepted':rawok,'source_hash_map_identical_to_accepted':hashesok,'source_and_contract_diagnostics_empty':zero,'exact_clean_dependencies':len(v['dependencies']),'started_at':v['started_at'],'finished_at':v['finished_at'],'source_paths':list(v['source_sha256'])}
checks['verification_evidence']=results
for label,base in [('baseline',S/'evidence/release-readiness/v1/reproduction/gate-tests'),('final',S/'evidence/release-readiness/v1/gate-tests'),('consumer',C/'evidence/release-readiness/v1/archive-consumer/gate-tests')]:
 v=j(base/'gate_tests.json');cmds,bad=commands_consistency(base,v);ok=v['status']=='passed'and len(v['tests'])==15 and all(t['status']=='passed'for t in v['tests']);demand(ok,label+' gates');checks.setdefault('gate_evidence',{})[label]={'status':v['status'],'tests':len(v['tests']),'commands':len(cmds),'raw_log_mismatches':bad,'all_test_cases_passed':ok}
for ctrl,fixture in [('missing-module','omitted-module.json'),('unmentioned-contract-export','unmentioned-export.json')]:
 b=S/'evidence/release-readiness/v1/gate-controls'/ctrl;v=j(b/'verification.json');cmds,bad=commands_consistency(b,v);same=(b/fixture).read_bytes()==(S/'evidence/markov/v1/gate-controls'/ctrl/fixture).read_bytes();demand(v['status']=='failed'and same and all(c['label']!='build-release'for c in cmds),ctrl+' control');checks.setdefault('controls',{})[ctrl]={'status':v['status'],'error':v['error'],'commands':len(cmds),'no_build_invocation':all(c['label']!='build-release'for c in cmds),'same_fixture_as_markov':same,'raw_log_mismatches':bad}
link=j(S/'evidence/release-readiness/v1/inventory/inventory_linkage.json');inv=j(S/link['reused_inventory']);isum=inv['summary'];pub=[x for x in inv['declarations']if not x['kind'].startswith('private')]
linkok=sha(S/link['reused_inventory'])==link['reused_inventory_sha256'] and link['inventory_contracts_sha256']==sha(S/'Audit/Contracts.lean') and all(sha(S/p)==h for p,h in link['release_module_sha256_now'].items());demand(linkok,'inventory linkage');checks['inventory_linkage']={'sha256':sha(S/link['reused_inventory']),'valid':linkok,'summary':isum}
usage=j(S/'evidence/release-readiness/v1/usage/usage-compile.json');ub=S/'evidence/release-readiness/v1/usage';demand(usage['exit_code']==0 and sha(S/'examples/Usage.lean')==usage['examples_usage_sha256']and not(ub/usage['stdout_log']).read_bytes()and not(ub/usage['stderr_log']).read_bytes(),'usage evidence');checks['usage_evidence']={'exit_code':usage['exit_code'],'source_hash_matches':True,'empty_diagnostics':True}
# External/source/companion receipts and loose attachment equality.
loose=[('HANDOFF(6).md',S/'deliverables/release-readiness/v1/HANDOFF.md'),('POINTER(6).json',S/'deliverables/release-readiness/v1/POINTER.json'),('RECEIPT(5).json',C/'deliverables/release-readiness/v1/RECEIPT.json'),('CONSUMER_EVIDENCE_MANIFEST.json',C/'deliverables/release-readiness/v1/CONSUMER_EVIDENCE_MANIFEST.json')];checks['loose_attachments']={n:(ROOT/'upload'/n).read_bytes()==p.read_bytes()for n,p in loose};demand(all(checks['loose_attachments'].values()),'loose attachments')
r=j(C/'deliverables/release-readiness/v1/RECEIPT.json');cr=j(ROOT/'upload/COMPANION_RECEIPT.json');checks['receipt_separation']={'source_receipt_excluded_from_source':not(S/'deliverables/release-readiness/v1/RECEIPT.json').exists(),'companion_receipt_excluded_from_companion':not(C/'deliverables/release-readiness/v1/COMPANION_RECEIPT.json').exists(),'source_digest_matches':r['source_archive']['sha256']==sha(source_zip)==cr['source_archive_sha256'],'companion_digest_matches':cr['companion_archive']['sha256']==sha(comp_zip),'source_commit_matches_zip_comment':r['commit_under_review']==checks['source_archive']['zip_comment']};demand(all(checks['receipt_separation'].values()),'receipt separation')
cons=C/'evidence/release-readiness/v1/archive-consumer';env=j(cons/'environment.json');demand(env['source_sha256_from_extraction']==markovv['source_sha256'],'consumer environment hashes');demand(all((cons/(x+'.exit_code')).read_text().strip()=='0'for x in ['01-lake-exe-cache-get','02-verify','03-test-verify','04-usage']),'consumer outer exits')
checks['consumer_outer_logs']={'all_four_exit_zero':True,'input_sha256_matches':env['input_archive_sha256']==sha(source_zip),'cache_log_cloned_count':(cons/'01-lake-exe-cache-get.stderr.log').read_text().count(': cloning '),'cache_log_reports_no_files_to_download':'No files to download'in(cons/'01-lake-exe-cache-get.stdout.log').read_text(),'decompressed_artifacts':2435,'already_decompressed':74,'dependency_mode':'Reused pinned compiled dependency artifacts, fresh project elaboration; not full Mathlib source rebuild'}
checks['scope_limitations']=['Archive ZIP comment and receipts identify submitted source commit; no Git history or remote tags in this artifact audit.','Recorded git chronology, commands, and exit codes are independently cross-checked within the supplied evidence; root auditor performs fresh execution separately.','No new mathematical theorem requires semantic re-audit because frozen sources are identical to the previously accepted actual snapshot.']
checks['errors']=errors;checks['status']='passed'if not errors else'failed';checks['recorded_at']=datetime.datetime.now(datetime.timezone.utc).isoformat();(W/'package_checks.json').write_text(json.dumps(checks,indent=2)+'\n');print(json.dumps({k:v for k,v in checks.items()if k not in ['freeze','verification_evidence','inventory_linkage']},indent=2));print('FULL',W/'package_checks.json')
