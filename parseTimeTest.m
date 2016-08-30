function tests = parseTimeTest
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
addpath(fullfile(getenv('WORKSPACE'),'parseTime'))
addpath(fullfile(getenv('WORKSPACE'),'num2sepstr'))
end
function teardownOnce(testCase)
path(testCase.TestData.orig_path)
end

function testGeneric(testCase)
verifyEqual(testCase,parseTime(3600*24*365-1),'52 weeks, 23 hours, 59 minutes, and 59 seconds')
verifyEqual(testCase,parseTime(3600*24*365-0.1),'52 weeks, 23 hours, 59 minutes, and 59.90 seconds')
verifyEqual(testCase,parseTime(123456789),'3 years, 47 weeks, 4 days, 21 hours, 33 minutes, and 9 seconds')
end
function testZero(testCase)
verifyEqual(testCase,parseTime(0),'0')
verifyEqual(testCase,parseTime(1e-9),'0')
verifyEqual(testCase,parseTime(-1e-9),'0')
end
function testSingularSecond(testCase)
verifyEqual(testCase,parseTime(1),'1 second')
verifyEqual(testCase,parseTime(1.001),'1 second')
end
function testUnitOmission(testCase)
verifyEqual(testCase,parseTime(60),'1 minute')
verifyEqual(testCase,parseTime(7200),'2 hours')
verifyEqual(testCase,parseTime(7201),'2 hours and 1 second')
verifyEqual(testCase,parseTime(7380),'2 hours and 3 minutes')
verifyEqual(testCase,parseTime(3600*24*365),'1 year')
end
function testNegative(testCase)
verifyEqual(testCase,parseTime(-1e-9),'0')
verifyEqual(testCase,parseTime(-1),'-1 second')
verifyEqual(testCase,parseTime(1-3600*24*365),'-52 weeks, 23 hours, 59 minutes, and 59 seconds')
verifyEqual(testCase,parseTime(0.1-3600*24*365),'-52 weeks, 23 hours, 59 minutes, and 59.90 seconds')
verifyEqual(testCase,parseTime(-123456789),'-3 years, 47 weeks, 4 days, 21 hours, 33 minutes, and 9 seconds')
end
% function testForceUnits(testCase)
% verifyEqual(testCase,parseTime(0, 0),'0')
% verifyEqual(testCase,parseTime(0, 1),'0 seconds')
% verifyEqual(testCase,parseTime(1e-9, 1),'0 seconds')
% verifyEqual(testCase,parseTime(3600*24*365-1, 0),'52 weeks, 23 hours, 59 minutes, and 59 seconds')
% verifyEqual(testCase,parseTime(3600*24*365-1, 1),'52 weeks, 23 hours, 59 minutes, and 59 seconds')
% end