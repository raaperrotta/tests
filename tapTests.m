import matlab.unittest.TestSuite;
import matlab.unittest.TestRunner;
import matlab.unittest.plugins.TAPPlugin;
import matlab.unittest.plugins.ToFile;

cd(getenv('WORKSPACE'))

restoredefaultpath

d = dir(getenv('WORKSPACE'));
folders = arrayfun(@(d)fullfile(getenv('WORKSPACE'),d.name),d([d.isdir]),'Uniform',false);
for ii = 3:length(folders)
    addpath(folders{ii});
end

thisversion = ['R',version('-release')];
if strcmp(thisversion,'R2015a') && ~verLessThan('matlab','8.5.1')
    thisversion = [thisversion,'SP1'];
end

try
    disp(getenv('WORKSPACE'))
    suite = TestSuite.fromFolder(fullfile(getenv('WORKSPACE'),'tests'));
    % Create a typical runner with text output
    runner = TestRunner.withTextOutput();
    % Add the TAP plugin and direct its output to a file
    tapFile = fullfile(getenv('WORKSPACE'),[thisversion,'TestResults.tap']);
    runner.addPlugin(TAPPlugin.producingOriginalFormat(ToFile(tapFile)));
    % Run the tests
    results = runner.run(suite);
    display(results);
catch e
    disp(getReport(e,'extended'));
    exit(1);
end
exit;