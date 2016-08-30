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
movegui(gcf,'onscreen')

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

