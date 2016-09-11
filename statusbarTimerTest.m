function tests = statusbarTimerTest()
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
testCase.TestData.orig_path = path();
% On my install, the perl script called in restoredefaultpath.m finds the
% stateflow folder twice. I don't know why but it throws an annoying
% warning.
state = warning('off','MATLAB:dispatcher:pathWarning');
restoredefaultpath()
warning(state)
addpath(fullfile(getenv('WORKSPACE'),'statusbarTimer'))
addpath(fullfile(getenv('WORKSPACE'),'parseTime'))
testCase.TestData.JFrameWarningState = ...
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
end
function teardownOnce(testCase)
path(testCase.TestData.orig_path)
warning(testCase.TestData.JFrameWarningState)
end

function testInCommandWindow(testCase)
t = verifyWarningFree(testCase,@()statusbarTimer());
verifyClass(testCase,t,'timer')
verifyWarningFree(testCase,@()stop(t));
end
function testMessage(testCase)
t = verifyWarningFree(testCase,@()statusbarTimer('Buongiorno!'));
data = get(t,'UserData'); % data = {prefix,starttime}
verifyTrue(testCase,strcmp(data{1},'Buongiorno!'))
verifyWarningFree(testCase,@()stop(t));

t = verifyWarningFree(testCase,@()statusbarTimer(0,'Buongiorno!'));
data = get(t,'UserData'); % data = {prefix,starttime}
verifyTrue(testCase,strcmp(data{1},'Buongiorno!'))
verifyWarningFree(testCase,@()stop(t));
end
function testNoPrint(testCase)
file = tempname;

t = verifyWarningFree(testCase,@()statusbarTimer(true));
diary(file)
verifyWarningFree(testCase,@()stop(t));
diary off

t = verifyWarningFree(testCase,@()statusbarTimer(0,true));
diary(file)
verifyWarningFree(testCase,@()stop(t));
diary off

verifyTrue(testCase,isempty(fileread(file)),fileread(file))
end
function testPrint(testCase)
file = tempname;
t = verifyWarningFree(testCase,@()statusbarTimer());
diary(file)
stop(t);
diary off
verifyFalse(testCase,isempty(fileread(file)),fileread(file))

file = tempname;
t = verifyWarningFree(testCase,@()statusbarTimer(false));
diary(file)
stop(t);
diary off
verifyFalse(testCase,isempty(fileread(file)),fileread(file))

file = tempname;
t = verifyWarningFree(testCase,@()statusbarTimer(0,false));
diary(file)
stop(t);
diary off
verifyFalse(testCase,isempty(fileread(file)),fileread(file))
end

function testInFigure(testCase)
fig = figure();
t = verifyWarningFree(testCase,@()statusbarTimer(fig));
verifyClass(testCase,t,'timer')
verifyWarningFree(testCase,@()stop(t));
drawnow()
t = verifyWarningFree(testCase,@()statusbarTimer(fig));
verifyClass(testCase,t,'timer')
verifyWarningFree(testCase,@()close(fig));
end
function testMessageInFigure(testCase)
fig = figure();
t = verifyWarningFree(testCase,@()statusbarTimer(fig,'Buongiorno!'));
data = get(t,'UserData'); % data = {prefix,starttime}
verifyTrue(testCase,strcmp(data{1},'Buongiorno!'))
verifyWarningFree(testCase,@()close(fig));
end
function testNoPrintInFigure(testCase)
file = tempname;
fig = figure();
verifyWarningFree(testCase,@()statusbarTimer(fig,true));
diary(file)
close(fig);
diary off
verifyTrue(testCase,isempty(fileread(file)),fileread(file))
end
function testPrintInFigure(testCase)
fig = figure();
file = tempname;
t = verifyWarningFree(testCase,@()statusbarTimer(fig));
diary(file)
stop(t);
diary off
verifyFalse(testCase,isempty(fileread(file)),fileread(file))

file = tempname;
t = verifyWarningFree(testCase,@()statusbarTimer(fig,false));
diary(file)
stop(t);
diary off
verifyFalse(testCase,isempty(fileread(file)),fileread(file))

close(fig)
end
function testJFrameWarning(testCase)
restore = onCleanup(@()warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame'));
warning('on','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame')
fig = figure();
verifyWarning(testCase,@()statusbarTimer(fig),'statusbarTimer:JFrame')
close(fig)
end
function testNum2SepStr(testCase)
orig_path = path();
restore = onCleanup(@()path(orig_path));
addpath(fullfile(getenv('WORKSPACE'),'num2sepstr'))

t = verifyWarningFree(testCase,@()statusbarTimer());
verifyClass(testCase,t,'timer')
verifyWarningFree(testCase,@()stop(t));

t = verifyWarningFree(testCase,@()statusbarTimer(gcf()));
verifyClass(testCase,t,'timer')
verifyWarningFree(testCase,@()stop(t));
end