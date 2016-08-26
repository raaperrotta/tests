import matlab.unittest.TestSuite;
import matlab.unittest.TestRunner;
import matlab.unittest.plugins.TAPPlugin;
import matlab.unittest.plugins.ToFile;

try
    disp(getenv('WORKSPACE'))
    suite = TestSuite.fromFolder(getenv('WORKSPACE'));
    % Create a typical runner with text output
    runner = TestRunner.withTextOutput();
    % Add the TAP plugin and direct its output to a file
    tapFile = fullfile(getenv('WORKSPACE'),[version('-release'),'TestResults.tap']);
    runner.addPlugin(TAPPlugin.producingOriginalFormat(ToFile(tapFile)));
    % Run the tests
    results = runner.run(suite);
    display(results);
catch e
    disp(getReport(e,'extended'));
    exit(1);
end
exit;