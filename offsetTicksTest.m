function tests = offsetTicksTest
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
addpath(fullfile(getenv('WORKSPACE'),'offsetTicks'))

x = (0:100) + 1e6;
y = sin(2*pi*x/50);
testCase.TestData.plotExample = @() {clf,plot(x,y)};
end
function teardownOnce(testCase)
path(testCase.TestData.orig_path)
end

function testGeneric(testCase)
% Shouldn't throw any warnings
testCase.TestData.plotExample();
verifyWarningFree(testCase,@()offsetTicks(gca,'xy'))
end

function testAxesLims(testCase)
% Don't change axis limits
testCase.TestData.plotExample();
orig_xlim = xlim();
orig_ylim = ylim();
offsetTicks(gca,'x')
drawnow()

verifyEqual(testCase,xlim(),orig_xlim)
verifyEqual(testCase,ylim(),orig_ylim)
end

function testTickLabels(testCase)
% Better get the tick labels right; that's kind-of the point...
testCase.TestData.plotExample();
offsetTicks(gca,'x')
drawnow()

xt = get(gca,'XTick');
lbl = [sprintf('%d',xt(1));arrayfun(@(x)sprintf('+%d',x-xt(1)),xt(2:end),'Uniform',false)'];
xlbl = get(gca,'XTickLabel');
verifyEqual(testCase,xlbl,lbl)
end

function testTickLabelWithZero(testCase)
% When the axis limits include zero, the ticks should be left alone
testCase.TestData.plotExample();
lbl = get(gca,'YTickLabel');
offsetTicks(gca,'y')
drawnow()

ylbl = get(gca,'YTickLabel');
verifyEqual(testCase,ylbl,lbl)
% But the listener should be there and should respond if we set the axis
% limits such that they no longer include zero
ylim([0.4,1.2])
yt = get(gca,'YTick');
lbl = [sprintf('%g',yt(1));arrayfun(@(y)sprintf('+%g',y-yt(1)),yt(2:end),'Uniform',false)'];
ylbl = get(gca,'YTickLabel');
verifyEqual(testCase,ylbl,lbl)
end

function testTickLabelSuffix(testCase)
testCase.TestData.plotExample();
offsetTicks(gca,'x','%f sec')
drawnow()

xt = get(gca,'XTick');
lbl = [sprintf('%d sec',xt(1));arrayfun(@(x)sprintf('+%d sec',x-xt(1)),xt(2:end),'Uniform',false)'];
xlbl = get(gca,'XTickLabel');
verifyEqual(testCase,xlbl,lbl)
end

function testTickLabelsWithSep(testCase)
orig_path = path;
restore = onCleanup(@()path(orig_path));
addpath(fullfile(getenv('WORKSPACE'),'num2sepstr'))

testCase.TestData.plotExample();
offsetTicks(gca,'x')
drawnow()

xt = get(gca,'XTick');
lbl = [num2sepstr(xt(1));arrayfun(@(x)sprintf('+%d',x-xt(1)),xt(2:end),'Uniform',false)'];

xlbl = get(gca,'XTickLabel');
verifyEqual(testCase,xlbl,lbl)
end

function testResize(testCase)
testCase.TestData.plotExample();
offsetTicks(gca,'x')
drawnow()

xt = get(gca,'XTick');
lbl = [sprintf('%d',xt(1));arrayfun(@(x)sprintf('+%d',x-xt(1)),xt(2:end),'Uniform',false)'];
xlbl = get(gca,'XTickLabel');
assumeEqual(testCase,xlbl,lbl)

fpos = get(gcf,'Position');
fpos = fpos.*[1,1,2,2];
set(gcf,'Position',fpos)

xlbl = get(gca,'XTickLabel');
verifyEqual(testCase,xlbl,lbl)
end

function testMultiAxis(testCase)
testCase.TestData.plotExample();
ylim([0.4,1.2])
offsetTicks(gca,'xy')
drawnow()

xt = get(gca,'XTick');
lbl = [sprintf('%d',xt(1));arrayfun(@(x)sprintf('+%d',x-xt(1)),xt(2:end),'Uniform',false)'];
xlbl = get(gca,'XTickLabel');
verifyEqual(testCase,xlbl,lbl)

yt = get(gca,'YTick');
lbl = [sprintf('%g',yt(1));arrayfun(@(y)sprintf('+%g',y-yt(1)),yt(2:end),'Uniform',false)'];
ylbl = get(gca,'YTickLabel');
verifyEqual(testCase,ylbl,lbl)
end

function test3D(testCase)
[X,Y,Z] = peaks(21);
surf(X+1e4,Y-1e6,Z+1e3)
offsetTicks(gca,'xyz')
drawnow()

xt = get(gca,'XTick');
lbl = [sprintf('%d',xt(1));arrayfun(@(x)sprintf('+%d',x-xt(1)),xt(2:end),'Uniform',false)'];
xlbl = get(gca,'XTickLabel');
verifyEqual(testCase,xlbl,lbl)

yt = get(gca,'YTick');
lbl = [sprintf('%d',yt(1));arrayfun(@(y)sprintf('+%d',y-yt(1)),yt(2:end),'Uniform',false)'];
ylbl = get(gca,'YTickLabel');
verifyEqual(testCase,ylbl,lbl)

zt = get(gca,'XTick');
lbl = [sprintf('%d',xt(1));arrayfun(@(z)sprintf('+%d',z-zt(1)),zt(2:end),'Uniform',false)'];
zlbl = get(gca,'XTickLabel');
verifyEqual(testCase,zlbl,lbl)
end

function testRemoveListeners(testCase)
testCase.TestData.plotExample();
ylim([0.4,1.2])
drawnow()

orig_xlbl = get(gca,'XTickLabel');
orig_ylbl = get(gca,'YTickLabel');

offsetTicks(gca,'xy')
drawnow()

xt = get(gca,'XTick');
lbl = [sprintf('%d',xt(1));arrayfun(@(x)sprintf('+%d',x-xt(1)),xt(2:end),'Uniform',false)'];
xlbl = get(gca,'XTickLabel');
assumeEqual(testCase,xlbl,lbl)

yt = get(gca,'YTick');
lbl = [sprintf('%g',yt(1));arrayfun(@(y)sprintf('+%g',y-yt(1)),yt(2:end),'Uniform',false)'];
ylbl = get(gca,'YTickLabel');
assumeEqual(testCase,ylbl,lbl)

offsetTicks(gca,'x','')
% drawnow()

xlbl = get(gca,'XTickLabel');
verifyEqual(testCase,xlbl,orig_xlbl)

offsetTicks(gca,'y',[])
% drawnow()

ylbl = get(gca,'YTickLabel');
verifyEqual(testCase,ylbl,orig_ylbl)

end

function testNewLineWarning(testCase)
testCase.TestData.plotExample();
verifyWarning(testCase,@()offsetTicks(gca,'x','%f\n'),'offsetTicks:newlineChar')
verifyWarning(testCase,@()offsetTicks(gca,'y','%8.4f\n'),'offsetTicks:newlineChar')
verifyWarning(testCase,@()offsetTicks(gca,'xy','Very\n%f'),'offsetTicks:newlineChar')
verifyWarning(testCase,@()offsetTicks(gca,'x','%f\nWatts'),'offsetTicks:newlineChar')
end

function testPlusSignWarning(testCase)
testCase.TestData.plotExample();
verifyWarning(testCase,@()offsetTicks(gca,'x','%+f'),'offsetTicks:signedPositive')
verifyWarning(testCase,@()offsetTicks(gca,'y','%+8.4f'),'offsetTicks:signedPositive')
verifyWarning(testCase,@()offsetTicks(gca,'xy','Very %+f'),'offsetTicks:signedPositive')
verifyWarning(testCase,@()offsetTicks(gca,'x','%+f Watts'),'offsetTicks:signedPositive')
verifyWarning(testCase,@()offsetTicks(gca,'y','%+g'),'offsetTicks:signedPositive')
verifyWarning(testCase,@()offsetTicks(gca,'xy','%+d'),'offsetTicks:signedPositive')
end

%
% function testOnAxesAtATime(testCase)
% testCase.TestData.plotExample();
% lim = xlim();
% lbl = get(gca,'XTickLabel');
% symlog('y');
% verifyEqual(testCase,xlim(),lim,num2str(xlim()))
% verifyEqual(testCase,get(gca,'XTickLabel'),lbl)
%
% testCase.TestData.plotExample();
% lim = ylim();
% lbl = get(gca,'YTickLabel');
% symlog('x');
% verifyEqual(testCase,ylim(),lim,num2str(ylim()))
% verifyEqual(testCase,get(gca,'YTickLabel'),lbl)
% end
