function tests = symlogTest
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
addpath(fullfile(getenv('WORKSPACE'),'symlog'))

x = linspace(-50,50,1e4+1);
y1 = x;
y2 = sin(x);
testCase.TestData.plotExample = @() {clf,plot(x,y1,x,y2)};
end
function teardownOnce(testCase)
path(testCase.TestData.orig_path)
end

function testGeneric(testCase)
testCase.TestData.plotExample();
verifyWarningFree(testCase,@()symlog())
end

function testAxesLims(testCase)
testCase.TestData.plotExample();
lim = [-100,100];
xlim(lim)
ylim(lim)
symlog()
C = 1; % the default value of 10^0
lim = sign(lim).*log10(1+abs(lim)/C);
verifyEqual(testCase,xlim(),lim,num2str(xlim()))
verifyEqual(testCase,ylim(),lim,num2str(ylim()))
end

function testTickLabels(testCase)
testCase.TestData.plotExample();
lim = [-100,100];
xlim(lim)
ylim(lim)
symlog()
C = 1; % the default value of 10^0
lim = sign(lim).*log10(1+abs(lim)/C);
assumeEqual(testCase,xlim(),lim,num2str(xlim()))
assumeEqual(testCase,ylim(),lim,num2str(ylim()))
lbl = {
    '-10^{2}'
    '-10^{1}'
    '-10^{0}'
    '0'
    '10^{0}'
    '10^{1}'
    '10^{2}'
};
xlbl = get(gca,'XTickLabel');
ylbl = get(gca,'YTickLabel');
verifyEqual(testCase,xlbl,lbl)
verifyEqual(testCase,ylbl,lbl)
end

function testResize(testCase)
testCase.TestData.plotExample();
lim = [-100,100];
xlim(lim)
ylim(lim)
symlog()
C = 1; % the default value of 10^0
lim = sign(lim).*log10(1+abs(lim)/C);
assumeEqual(testCase,xlim(),lim,num2str(xlim()))
assumeEqual(testCase,ylim(),lim,num2str(ylim()))
lbl = {
    '-10^{2}'
    '-10^{1}'
    '-10^{0}'
    '0'
    '10^{0}'
    '10^{1}'
    '10^{2}'
};
xlbl = get(gca,'XTickLabel');
ylbl = get(gca,'YTickLabel');
assumeEqual(testCase,xlbl,lbl)
assumeEqual(testCase,ylbl,lbl)

fpos = get(gcf,'Position');
fpos = fpos.*[1,1,2,2];
set(gcf,'Position',fpos)

verifyEqual(testCase,xlim(),lim,num2str(xlim()))
verifyEqual(testCase,ylim(),lim,num2str(ylim()))
xlbl = get(gca,'XTickLabel');
ylbl = get(gca,'YTickLabel');
verifyEqual(testCase,xlbl,lbl)
verifyEqual(testCase,ylbl,lbl)
end

function testOnAxesAtATime(testCase)
testCase.TestData.plotExample();
lim = xlim();
lbl = get(gca,'XTickLabel');
symlog('y');
verifyEqual(testCase,xlim(),lim,num2str(xlim()))
verifyEqual(testCase,get(gca,'XTickLabel'),lbl)

testCase.TestData.plotExample();
lim = ylim();
lbl = get(gca,'YTickLabel');
symlog('x');
verifyEqual(testCase,ylim(),lim,num2str(ylim()))
verifyEqual(testCase,get(gca,'YTickLabel'),lbl)
end

function testTransformPatches(testCase)
testCase.TestData.plotExample();
X = [20,1,-40,-1]';
Y = [0,30,0,-30]';
h = patch(X,Y,[0.8,0.2,0.2]);
symlog('x')
C = 1; % the default value of 10^0
X = sign(X).*log10(1+abs(X)/C);
verifyLessThan(testCase,abs(h.XData-X),1e-12)
verifyLessThan(testCase,abs(h.YData-Y),1e-12)
end

function testTransformRectangles(testCase)
testCase.TestData.plotExample();

pos = [-20,-40,40,42];
X = pos(1) + [0, pos(3)];
Y = pos(2) + [0, pos(4)];
h = rectangle('Position',pos);

symlog('x')

C = 1; % the default value of 10^0
X = sign(X).*log10(1+abs(X)/C);

X2 = h.Position(1) + [0, h.Position(3)];
Y2 = h.Position(2) + [0, h.Position(4)];
verifyLessThan(testCase,abs(X2-X),1e-12)
verifyLessThan(testCase,abs(Y2-Y),1e-12)

symlog('x', -1)

C = 10^-1;
X = pos(1) + [0, pos(3)];
X = sign(X).*log10(1+abs(X)/C);

X2 = h.Position(1) + [0, h.Position(3)];
Y2 = h.Position(2) + [0, h.Position(4)];
verifyLessThan(testCase,abs(X2-X),1e-12)
verifyLessThan(testCase,abs(Y2-Y),1e-12)
end









