import sys
import os
import subprocess
import json

REPO_NAME = "test-evolve-bears-fer"

print "Enter in script"

branch = sys.argv[1]
print "Branch received: %s" % branch

cmd = "git checkout %s;" % branch
subprocess.call(cmd, shell=True)

cmd = "git rev-parse HEAD~2;"
buggy_commit = subprocess.check_output(cmd, shell=True).replace("\n", "")
print buggy_commit

cmd = "git rev-parse HEAD~1;"
fixed_commit = subprocess.check_output(cmd, shell=True).replace("\n", "")
print fixed_commit

cmd = "git diff %s %s -- '*.java';" % (buggy_commit, fixed_commit)
human_patch = subprocess.check_output(cmd, shell=True)

with open('bears.json') as original_json_file:
    bug = json.load(original_json_file)
    bug['repository']['name'] = bug['repository']['name'].replace("/","-")
    bug['branchUrl'] = "https://github.com/fermadeiral/" + REPO_NAME + "/tree/" + branch
    bug['diff'] = human_patch

cmd = "git checkout -qf master;"
subprocess.call(cmd, shell=True)

bugs = None
if os.path.exists(os.path.join("docs", "data", "bears-bugs.json")):
    with open(os.path.join("docs", "data", "bears-bugs.json"),'r') as f:
        try:
            bugs = json.load(f)
            print('loaded that: ',bugs)
        except Exception as e:
            print("got %s on json.load()" % e)

if bugs is None:
    print('each time I am creating the new one')
    bugs = bug
else:
    bugs.append(bug)

with open(os.path.join("docs", "data", "bears-bugs.json"), mode='w') as fd:
    fd.write(json.dumps(bugs, indent=2))

cmd = "git add -A; git commit -m %s; git push github;" % branch
subprocess.call(cmd, shell=True)