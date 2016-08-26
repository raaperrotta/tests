import matlab.unittest.TestSuite;
import matlab.unittest.TestRunner;
import matlab.unittest.plugins.TAPPlugin;
import matlab.unittest.plugins.ToFile;

wrk = getenv('WORKSPACE'); % Jenkins environment variable

cd(wrk)

thisversion = ['R',version('-release')];
if strcmp(thisversion,'R2015a') && ~verLessThan('matlab','8.5.1')
    thisversion = [thisversion,'SP1'];
end

try
    suite = TestSuite.fromFolder(fullfile(wrk));
    % Create a typical runner with text output
    runner = TestRunner.withTextOutput();
    % Add the TAP plugin and direct its output to a file
    tapFile = fullfile(wrk,[thisversion,'TestResults.tap']);
    runner.addPlugin(TAPPlugin.producingOriginalFormat(ToFile(tapFile)));
    % Run the tests
    results = runner.run(suite);
    display(results);
catch e
    disp(getReport(e,'extended'));
    exit(1);
end
exit;