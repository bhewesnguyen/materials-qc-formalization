from pathlib import Path,PurePosixPath
import zipfile,json,hashlib,stat,shutil
B=Path('/workspace/scratch/0a42b15a2c38/audit_release_readiness');U=B.parent/'upload'
def sha(b):return hashlib.sha256(b).hexdigest()
result={}
for label,fn,dest,mp,prefix,expected,nbytes in [
 ('source','Formal_Science_Release_Readiness_Handoff.zip','submitted','formal-science/SOURCE_MANIFEST.json','formal-science/','e97dfc620b50a2a6a2d9de51b33ec009d6dfd17ea7acd3987ddc9d0096c408e0',3553183),
 ('companion','Formal_Science_Release_Readiness_Consumer_Evidence.zip','companion','deliverables/release-readiness/v1/CONSUMER_EVIDENCE_MANIFEST.json','','7c6bca2065fb4c0068ef2d1265b97197d09dbedd0173e33f34983f2442d35553',142213)]:
 p=U/fn;digest=sha(p.read_bytes());assert digest==expected and p.stat().st_size==nbytes
 with zipfile.ZipFile(p) as z:
  infos=z.infolist();names=[x.filename for x in infos];assert len(names)==len(set(names));assert z.testzip() is None
  for x in infos:
   pp=PurePosixPath(x.filename);assert not pp.is_absolute() and '..' not in pp.parts and '\\' not in x.filename and not stat.S_ISLNK(x.external_attr>>16)
   assert not x.filename.lower().endswith('.zip')
  files={x.filename for x in infos if not x.is_dir()};man=json.loads(z.read(mp));rec=man['files'];rec={x['path']:x for x in rec} if isinstance(rec,list) else rec
  assert files=={prefix+n for n in rec}|{mp}
  for n,r in rec.items():
   data=z.read(prefix+n);assert len(data)==r['bytes'] and sha(data)==r['sha256'],n
  z.extractall(B/dest)
  result[label]={'file':fn,'sha256':digest,'bytes':nbytes,'manifest_payloads':len(rec),'actual_files':len(files),'zip_comment':z.comment.decode(),'crc_pass':True,'all_paths_safe_unique':True,'exact_manifest_path_set':True,'all_hashes_and_sizes_match':True,'nested_archives':False}
S=B/'submitted/formal-science';C=B/'companion';d='deliverables/release-readiness/v1/'
for fn,target in [('HANDOFF(6).md',S/(d+'HANDOFF.md')),('POINTER(6).json',S/(d+'POINTER.json')),('RECEIPT(5).json',C/(d+'RECEIPT.json')),('CONSUMER_EVIDENCE_MANIFEST.json',C/(d+'CONSUMER_EVIDENCE_MANIFEST.json'))]:assert (U/fn).read_bytes()==target.read_bytes(),fn
assert not (S/(d+'RECEIPT.json')).exists() and not (C/(d+'COMPANION_RECEIPT.json')).exists()
result['detached_files_match']=True;result['source_receipt_external_to_source_archive']=True;result['companion_receipt_external_to_companion_archive']=True
(B/'evidence/archive_integrity.json').write_text(json.dumps(result,indent=2)+'\n')
for x,n in [('RECEIPT(5).json','input_source_receipt.json'),('COMPANION_RECEIPT.json','input_companion_receipt.json')]:shutil.copyfile(U/x,B/'evidence'/n)
print(json.dumps(result,indent=2))
