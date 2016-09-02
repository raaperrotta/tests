function tapTests(name)

import matlab.unittest.TestSuite;
import matlab.unittest.TestRunner;
import matlab.unittest.plugins.TAPPlugin;
import matlab.unittest.plugins.ToFile;

if nargin == 0
    name = ''; % run all tests
end

wrk = getenv('WORKSPACE'); % Jenkins environment variable

cd(wrk)

thisversion = ['R',version('-release')];
if strcmp(thisversion,'R2015a') && ~verLessThan('matlab','8.5.1')
    thisversion = [thisversion,'SP1'];
end

try
    fprintf('Fetching tests from "%s."',fullfile(wrk,name))
    ls(fullfile(wrk,name))
    suite = TestSuite.fromFolder(fullfile(wrk,name));
    % Create a typical runner with text output
    runner = TestRunner.withTextOutput();
    % Add the TAP plugin and direct its output to a file
    tapFile = fullfile(wrk,[name,'_',thisversion,'_TestResults.tap']);
    runner.addPlugin(TAPPlugin.producingOriginalFormat(ToFile(tapFile)));
    % Run the tests
    results = runner.run(suite);
    display(results);
catch e
    disp(getReport(e,'extended'));
    exit(1);
end
exit;
