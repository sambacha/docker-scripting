<?xml version="1.0" encoding="UTF-8"?>
<testsuite tests="2" failures="2">
<testcase classname="foo.bash" name="foo.bash">
<failure type="ShellCheck.SC2148">Line 1: Tips depend on target shell and yours is unknown. Add a shebang. See https://www.shellcheck.net/wiki/SC2148</failure>
<failure type="ShellCheck.SC2086">Line 1: Double quote to prevent globbing and word splitting. See https://www.shellcheck.net/wiki/SC2086</failure>
</testcase>
<testcase classname