function tests = statusbarTimerTest()
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
testCase.TestData.orig_path = path();
restoredefaultpath()
addpath('../statusbarTimer')
addpath('../parseTime')
addpath('../num2sepstr')
end
function teardownOnce(testCase)
path(testCase.TestData.orig_path)
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
verifyWarningFree(testCase,@()close(fig));
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
