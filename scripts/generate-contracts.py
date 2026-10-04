#!/usr/bin/env python3
"""Bundle the audience contracts, then generate Spring boundaries and the consumer SDK."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import urllib.request

ROOT = Path(__file__).resolve().parents[1]
VERSION = '7.15.0'
SHA256 = '4da1a7cdb78c3a43b1eab0648891135e8c3547d2eedba0dd69daf377f865f366'

def run(args, cwd=ROOT):
    subprocess.run(args, cwd=cwd, check=True)

def main():
    java = shutil.which('java')
    flutter = shutil.which('flutter') or shutil.which('flutter.bat')
    dart = shutil.which('dart') or shutil.which('dart.bat')
    if not all((java, flutter, dart)):
        raise SystemExit('Install JDK 21 and Flutter 3.47.6; add java, flutter and dart to PATH.')
    cache = ROOT / '.local' / 'tools'
    cache.mkdir(parents=True, exist_ok=True)
    jar = cache / f'openapi-generator-cli-{VERSION}.jar'
    if not jar.exists():
        urllib.request.urlretrieve(f'https://repo.maven.apache.org/maven2/org/openapitools/openapi-generator-cli/{VERSION}/openapi-generator-cli-{VERSION}.jar', jar)
    if hashlib.sha256(jar.read_bytes()).hexdigest() != SHA256:
        raise SystemExit('OpenAPI Generator checksum mismatch. Remove the cached jar and retry.')
    specs = ROOT / 'contracts' / 'openapi'
    consumer = json.loads((specs / 'consumer.yaml').read_text(encoding='utf-8'))
    backyard = json.loads((specs / 'backyard.yaml').read_text(encoding='utf-8'))
    shared = json.loads((specs / 'shared.yaml').read_text(encoding='utf-8'))
    bundle = {**consumer, 'info': {**consumer['info'], 'title': 'Recycle Gang Local API'},
              'paths': {**consumer['paths'], **backyard['paths']},
              'components': {**consumer['components'], 'schemas': shared['components']['schemas']}}
    (specs / 'bundled.yaml').write_text(json.dumps(bundle, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    common = [java, '-jar', str(jar), 'generate', '--global-property', 'apiTests=false,modelTests=false,apiDocs=false,modelDocs=false']
    sdk = ROOT / 'flutter/packages/recycle_gang_api'
    for folder in (ROOT / 'backend/generated/src/main/java', sdk / 'lib'):
        if folder.exists():
            shutil.rmtree(folder)
    run(common + ['-g', 'spring', '-i', str(specs / 'bundled.yaml'), '-c', 'backend/openapi-config.json', '-o', 'backend/generated'])
    run(common + ['-g', 'dart-dio', '-i', str(specs / 'consumer.yaml'), '-c', 'contracts/dart-generator.json', '-t', 'contracts/templates/dart', '-o', str(sdk)])
    run([dart, 'pub', 'get'], sdk)
    run([dart, 'run', 'build_runner', 'build', '--delete-conflicting-outputs'], sdk)
    run([dart, 'format', 'lib'], sdk)
    for generated in (ROOT / 'backend/generated/src/main/java', sdk / 'lib'):
        for source in generated.rglob('*'):
            if source.suffix in ('.java', '.dart'):
                source.write_text('\n'.join(line.rstrip() for line in source.read_text(encoding='utf-8').splitlines()).rstrip() + '\n', encoding='utf-8')
    run([flutter, 'pub', 'get'], ROOT / 'flutter')
    print('Generated Spring APIs/models and consumer Dart SDK.')

if __name__ == '__main__':
    main()
