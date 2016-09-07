function tapTests(name)

import matlab.unittest.TestSuite;
import matlab.unittest.TestRunner;
import matlab.unittest.plugins.TAPPlugin;
import matlab.unittest.plugins.ToFile;

if nargin == 0
    name = ''; % run all tests
end

wrk = getenv('WORKSPACE'); % Jenkins environment variable

% if ~isempty(wrk)
%     cd(wrk)
% end

thisversion = ['R',version('-release')];
if strcmp(thisversion,'R2015a') && ~verLessThan('matlab','8.5.1')
    thisversion = [thisversion,'SP1'];
end

% Set default figure position to off-screen to avoid interruptions
scrn = get(0,'ScreenSize');
pos = get(0,'DefaultFigurePosition');
pos(1) = pos(1) + scrn(3); % sliiiiide to the right!
set(0,'DefaultFigurePosition',pos);

try
    fprintf('Fetching tests from "%s."\n',fullfile(wrk,name))
    if nargin==0
        suite = TestSuite.fromFolder(wrk);
    else
        suite = TestSuite.fromFile(fullfile(wrk,name));
    end
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
