from pathlib import Path
import hashlib,json,re,importlib.util,difflib,zipfile
base=Path('/workspace/scratch/0a42b15a2c38')
p=base/'audit_markov/submitted/formal-science'
old=base/'audit_convergence/submitted/formal-science'
out=base/'audit_markov/work'
def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()
def js(path): return json.loads(path.read_text())
a=js(old/'SOURCE_MANIFEST.json')['files']; b=js(p/'SOURCE_MANIFEST.json')['files']
changes=[x for x in a if x in b and a[x]!=b[x]]
r={'scope':'Independent package, historical payload and recorded-evidence inspection. Root auditor runs fresh Lean.','comparison':{'prior_payload':len(a),'current_payload':len(b),'changed':changes,'removed':sorted(set(a)-set(b)),'added_count':len(set(b)-set(a))}}
for prefix in ['evidence/','audits/','deliverables/']:
 paths=[x for x in a if x.startswith(prefix)]
 bad=[x for x in paths if not (p/x).exists() or sha(old/x)!=sha(p/x)]
 r['comparison'][prefix]={'previous_paths':len(paths),'mismatches':bad}
returns=[]
for m in sorted(p.glob('audits/*/v1/RETURN_MANIFEST.json')):
 d=js(m);bad=[];relocated=[]
 for path,expect in d['files'].items():
  q=p/path
  if m.parent.parent.name=='dissipator' and '/' not in path:
   q=m.parent/path;relocated.append({'original_key':path,'preserved_path':str(q.relative_to(p))})
  if not q.exists() or sha(q)!=expect['sha256'] or q.stat().st_size!=expect['bytes']:bad.append(path)
 returns.append({'manifest':str(m.relative_to(p)),'payloads':len(d['files']),'mismatches':bad,'documented_legacy_relocations':relocated})
r['historical_return_manifests']=returns
priorreturn=base/'audit_convergence/return'
paths=[x.relative_to(priorreturn) for x in priorreturn.rglob('*') if x.is_file()]
r['convergence_return_exact_local_match']={'files_including_manifest':len(paths),'mismatches':[str(x) for x in paths if not (p/x).exists() or sha(priorreturn/x)!=sha(p/x)]}
zipold=base/'audit_convergence/output/Formal_Science_Convergence_Audit_Return_v1.zip'
r['prior_return_zip_sha256']=sha(zipold)
spec=importlib.util.spec_from_file_location('verify_audit',p/'scripts/verify.py');mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
strip=mod.strip_lean_comments
r['accepted_source_comment_only']={x:''.join(strip((old/x).read_text()).split())==''.join(strip((p/x).read_text()).split()) for x in changes if x.startswith('FormalScience/')}
for field,paths in [('scripts_pins_unchanged',['scripts/verify.py','scripts/test_verify.py','lean-toolchain','lakefile.toml','lake-manifest.json']),('six_accepted_modules_unchanged',[x for x in a if x.startswith('FormalScience/') and x.endswith('.lean') and not x.endswith('TwoStateConvergence.lean')])]:
 r[field]={x:sha(old/x)==sha(p/x) for x in paths}
manifest=js(p/'exports.json');oldmanifest=js(old/'exports.json')
r['export_growth']={k:{'before':len(oldmanifest[k]),'after':len(manifest[k]),'previous_prefix_preserved':manifest[k][:len(oldmanifest[k])]==oldmanifest[k]} for k in ['release_modules','exports','contract_exports']}
contract=strip((p/'Audit/Contracts.lean').read_text())
actual=[]
for module in manifest['release_modules']:
 path=p/(module.replace('.','/')+'.lean');text=strip(path.read_text())
 namespaces=re.findall(r'^namespace\s+(\S+)\s*$',text,re.M);assert len(namespaces)==1,(module,namespaces)
 ns=namespaces[0]
 for m in re.finditer(r'^(?:@\[[^\]]*\]\s*)?((?:(?:private|noncomputable)\s+)*)(theorem|lemma|def|abbrev)\s+(\S+)',text,re.M):
  actual.append({'module':module,'kind':m[2],'name':ns+'.'+m[3],'private':'private' in m[1]})
public=[x for x in actual if not x['private']];thms=[x for x in public if x['kind']in ['theorem','lemma']]
private=[x for x in actual if x['private']]
consumed=[x['name'] for x in thms if re.search(r'(?<![A-Za-z0-9_.])'+re.escape(x['name'])+r'(?![A-Za-z0-9_.])',contract)]
submitted_inventory=js(p/'evidence/markov/v1/inventory/declaration_inventory.json')
r['independent_source_inventory']={'method':'Top-level declarations in comment-stripped source, checked single namespace per module; exact qualified consumer tokens in comment-stripped contracts. Direct application examples manually read. This is a source audit, not proof of arbitrary adversarial syntax coverage.','public':len(public),'theorems':len(thms),'definitions_abbrevs':len(public)-len(thms),'private':len(private),'missing_exports':sorted(set(x['name'] for x in public)-set(manifest['exports'])),'unknown_exports':sorted(set(manifest['exports'])-set(x['name'] for x in public)),'missing_contract_tokens':sorted(set(x['name'] for x in thms)-set(consumed)),'inventory_names_match':set(x['name']for x in actual)==set(x['name']for x in submitted_inventory['declarations']),'contract_hash_matches_inventory':sha(p/'Audit/Contracts.lean')==submitted_inventory['summary']['contracts_sha256']}
basever=js(p/'evidence/markov/v1/reproduction/verification/verification.json');oldver=js(old/'evidence/convergence/v1/verification/verification.json')
r['baseline_matches_accepted']={'source_hashes_equal':basever['source_sha256']==oldver['source_sha256'],'axioms_equal':basever['axioms']==oldver['axioms'],'manifest_equal':basever['manifest']==oldver['manifest']}
logs={}
for key,sub in [('baseline','reproduction/verification'),('final','verification')]:
 dpath=p/'evidence/markov/v1'/sub;v=js(dpath/'verification.json');commands=v['commands'];bad=[]
 for c in commands:
  for stream in ['stdout','stderr']:
   if (dpath/c[stream+'_file']).read_text()!=c[stream]:bad.append(c['label']+':'+stream)
 axcmd=next(c for c in commands if c['label']=='axiom-audit')
 ax=mod.parse_axiom_output(axcmd['stdout'],v['manifest']['exports'])
 logs[key]={'status':v['status'],'commands':len(commands),'nonzero_commands':[c['label']for c in commands if c['exit_code']!=0],'commands_json_equal':js(dpath/'commands.json')==commands,'raw_log_mismatches':bad,'exports':len(v['axioms']),'contracts':len(v['manifest']['contract_exports']),'axioms_parsed_equal':ax==v['axioms'],'axiom_sets':sorted(set(tuple(sorted(x))for x in ax.values())),'source_hash_mismatches':[] if key=='baseline' else [name for name,h in v['source_sha256'].items() if sha(p/name)!=h]}
for key,sub in [('baseline_gate_tests','reproduction/gate-tests'),('final_gate_tests','gate-tests')]:
 dpath=p/'evidence/markov/v1'/sub;v=js(dpath/'gate_tests.json');cmds=js(dpath/'commands.json')
 logs[key]={'status':v['status'],'cases':len(v['tests']),'failed_cases':[t for t in v['tests']if t['status']!='passed'],'raw_log_mismatches':[c['label']+':'+s for c in cmds for s in ['stdout','stderr']if (dpath/c[s+'_file']).read_text()!=c[s]]}
signature_maps={}
for label,sub in [('baseline','reproduction/verification'),('final','verification')]:
 v=js(p/'evidence/markov/v1'/sub/'verification.json')
 c=next(c for c in v['commands'] if c['label']=='export-signatures')
 messages=[json.loads(line) for line in c['stdout'].splitlines() if line.strip()]
 signature_maps[label]={m['data'].split(' :',1)[0].split('.{',1)[0]:m['data'] for m in messages}
 logs[label]['signature_report_count']=len(messages)
 logs[label]['signature_severities']=sorted(set(m['severity'] for m in messages))
r['earlier_elaborated_signature_differences']=[name for name,data in signature_maps['baseline'].items() if signature_maps['final'].get(name)!=data]
r['submitted_evidence']=logs
controls={}
for name,fixture in [('missing-module','omitted-module.json'),('unmentioned-contract-export','unmentioned-export.json')]:
 dpath=p/'evidence/markov/v1/gate-controls'/name;d=js(dpath/'verification.json');fix=js(dpath/fixture)
 controls[name]={'status':d['status'],'error':d['error'],'commands_before_rejection':len(d['commands']),'fixture_changes':{key:{'removed':sorted(set(manifest[key])-set(fix[key])),'added':sorted(set(fix[key])-set(manifest[key]))}for key in ['release_modules','exports','contract_exports'] if manifest[key]!=fix[key]},'failure_record_contains_manifest':'manifest' in d,'no_build':all(c['label']!='build'for c in d['commands'])}
r['controls']=controls
r['historical_contracts_preserved']=''.join(strip((old/'Audit/Contracts.lean').read_text()).split()).replace('endJumpContracts','') in ''.join(contract.split())
issued=(p/'audits/convergence/v1/NEXT_FABLE_TASK.md').read_text();active=(p/'NEXT_FABLE_TASK.md').read_text();start=active.index('Milestone key:')
r['issued_task_active_body_preserved']=active[start:]==issued[issued.index('Milestone key:'):]
r['loose_memo_matches']=(base/'upload/SCOPE_MEMO.md').read_bytes()==(p/'docs/SCOPE_MEMO.md').read_bytes()
r['release_metadata_files']=[str(x.relative_to(p))for x in p.iterdir()if x.is_file() and any(x.name.startswith(y)for y in ['LICENSE','COPYING','NOTICE','CITATION','AUTHORS','CONTRIBUTING'])]
r['findings']=[{'id':'M1-proposed','severity':'low','file':'README.md','detail':'The general-dimensional exclusion still says beyond the generic Kraus and dissipator layers, omitting the new arbitrary-finite-index Markov generator bridge. Update scope wording on acceptance.'}]
(out/'package_checks.json').write_text(json.dumps(r,indent=2)+'\n')
print(json.dumps(r,indent=2))
