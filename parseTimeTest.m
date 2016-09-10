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
verifyEqual(testCase,parseTime(3600*24*365-1.1),'52 weeks, 23 hours, 59 minutes, and 59 seconds')
verifyEqual(testCase,parseTime(123456789),'3 years, 47 weeks, 4 days, 21 hours, 33 minutes, and 9 seconds')
end
function testZero(testCase)
verifyEqual(testCase,parseTime(0),'0')
verifyEqual(testCase,parseTime(1e-9),'0')
verifyEqual(testCase,parseTime(-1e-9),'0')
end
function testSingularSecond(testCase)
verifyEqual(testCase,parseTime(1),'1.000 second')
verifyEqual(testCase,parseTime(1.0001),'1.000 second')
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
verifyEqual(testCase,parseTime(-1),'-1.000 second')
verifyEqual(testCase,parseTime(1-3600*24*365),'-52 weeks, 23 hours, 59 minutes, and 59 seconds')
verifyEqual(testCase,parseTime(1.1-3600*24*365),'-52 weeks, 23 hours, 59 minutes, and 59 seconds')
verifyEqual(testCase,parseTime(-123456789),'-3 years, 47 weeks, 4 days, 21 hours, 33 minutes, and 9 seconds')
end
function testPrecision(testCase)
verifyEqual(testCase,parseTime(1e-6),'0.000001 seconds')
verifyEqual(testCase,parseTime(-1e-6),'-0.000001 seconds')
verifyEqual(testCase,parseTime(1e-6,7),'0.0000010 seconds')
verifyEqual(testCase,parseTime(1e-6,5),'0')
verifyEqual(testCase,parseTime(1+1e-6,5),'1.00000 second')
verifyEqual(testCase,parseTime(1+5e-6,5),'1.00001 seconds')
verifyEqual(testCase,parseTime(0.999,3),'0.999 seconds')
verifyEqual(testCase,parseTime(0.9994999,3),'0.999 seconds')
verifyEqual(testCase,parseTime(0.9995,3),'1.000 second')
verifyEqual(testCase,parseTime(0.99995,4),'1.0000 second')
% Have to watch out for that rounding to avoid '1.0000 seconds'
verifyEqual(testCase,parseTime(0.99995),'1.000 second')
verifyEqual(testCase,parseTime(-0.99995),'-1.000 second')
verifyEqual(testCase,parseTime(-9.9995),'-10.000 seconds')
end