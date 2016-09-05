function tests = maketransparentTests
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
addpath(fullfile(getenv('WORKSPACE'),'maketransparent'))

x = linspace(-10,10,50);
y1 = 2*x/max(x);
y2 = sin(x);
testCase.TestData.plotExample = @() {
    clf
    plot(x,y1,'.',x,y2,'MarkerSize',42,'LineWidth',8)
    };
end
function teardownOnce(testCase)
path(testCase.TestData.orig_path)
end

function testGeneric(testCase)
h = testCase.TestData.plotExample();
drawnow()
h = h{2};
verifyWarningFree(testCase,@()maketransparent(gca,0.5))
verifyEqual(testCase,h(1).MarkerHandle.EdgeColorData(4),uint8(128))
verifyEqual(testCase,h(2).Edge.ColorData(4),uint8(128))
h(1).Marker = 'o';
h(1).MarkerFaceColor = h(1).MarkerEdgeColor;
drawnow()
verifyEqual(testCase,h(1).MarkerHandle.FaceColorData(4),uint8(128))
end

function testSetByHandle(testCase)
h = testCase.TestData.plotExample();
drawnow()
h = h{2};
verifyWarningFree(testCase,@()maketransparent(h,0.5))
verifyEqual(testCase,h(1).MarkerHandle.EdgeColorData(4),uint8(128))
verifyEqual(testCase,h(2).Edge.ColorData(4),uint8(128))

h = testCase.TestData.plotExample();
drawnow()
h = h{2};
verifyWarningFree(testCase,@()maketransparent(h(1),0.5))
drawnow()
verifyEqual(testCase,h(1).MarkerHandle.EdgeColorData(4),uint8(128))
verifyTrue(testCase,numel(h(2).Edge.ColorData)==3|h(2).Edge.ColorData(4)==255)
end

function testResizeFigure(testCase)
h = testCase.TestData.plotExample();
drawnow()
h = h{2};
maketransparent(gca,0.5)
assumeEqual(testCase,h(1).MarkerHandle.EdgeColorData(4),uint8(128))
assumeEqual(testCase,h(2).Edge.ColorData(4),uint8(128))


pos = get(gcf,'Position');
k = 1.1;
pos(1:2) = pos(1:2) - (k-1)/2*pos(3:4);
pos(3:4) = k*pos(3:4);
set(gcf,'Position',pos)
drawnow()
verifyEqual(testCase,h(1).MarkerHandle.EdgeColorData(4),uint8(128))
verifyEqual(testCase,h(2).Edge.ColorData(4),uint8(128))
end