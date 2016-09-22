function results = editSimDataTest
results = functiontests(localfunctions());
end

function setupOnce(testCase)
testCase.TestData.orig_path = path();
% On my install, the perl script called in restoredefaultpath.m finds the
% stateflow folder twice. I don't know why but it throws an annoying
% warning.
state = warning('off','MATLAB:dispatcher:pathWarning');
restoredefaultpath()
warning(state)
addpath(fullfile(getenv('WORKSPACE'),'editSimData'))

x = Simulink.SimulationData.Dataset();
s = Simulink.SimulationData.Signal();
s.Name = 'Signal1';
s.Values.sin_t = timeseries(sin(0:10),0:10);
s.Values.cos_t = timeseries(cos(0:10),0:10);
x = x.addElement(s);
s.Name = 'Signal2';
x = x.addElement(s);
testCase.TestData.x = x;
end
function teardownOnce(testCase)
path(testCase.TestData.orig_path)
end

function testNoOp(testCase)
x = testCase.TestData.x;
y = editSimData(x,'','',@(ts)ts);
verifyEqual(testCase,y,x)
y = editSimData(x,'','Data',@(d)d);
verifyEqual(testCase,y,x)
y = editSimData(x,'','Time',@(t)t);
verifyEqual(testCase,y,x)

y = editSimData(x,'Signal1','',@(ts)ts);
verifyEqual(testCase,y,x)
y = editSimData(x,'Signal1','Data',@(d)d);
verifyEqual(testCase,y,x)
y = editSimData(x,'Signal1','Time',@(t)t);
verifyEqual(testCase,y,x)
end

function testBiasTime(testCase)
x = testCase.TestData.x;
b = -1;

x1 = x.getElement(1);
x1.Values.sin_t.Time = x1.Values.sin_t.Time + b;
z = x.setElement(1,x1);

y = editSimData(x,'Signal1.sin_t','Time',@(t)t+b);
verifyEqual(testCase,y,z)

x1.Values.cos_t.Time = x1.Values.cos_t.Time + b;
z = x.setElement(1,x1);

y = editSimData(x,'Signal1','Time',@(t)t+b);
verifyEqual(testCase,y,z)

x2 = x.getElement(2);
x2.Values.sin_t.Time = x2.Values.sin_t.Time + b;
x2.Values.cos_t.Time = x2.Values.cos_t.Time + b;
z = z.setElement(2,x2);

y = editSimData(x,'','Time',@(t)t+b);
verifyEqual(testCase,y,z)
end

function testZeroData(testCase)
x = testCase.TestData.x;

x1 = x.getElement(1);
x1.Values.sin_t.Data = x1.Values.sin_t.Data*0;
z = x.setElement(1,x1);

y = editSimData(x,'Signal1.sin_t','Data',@(x)x*0);
verifyEqual(testCase,y,z)

x1.Values.cos_t.Data = x1.Values.cos_t.Data*0;
z = x.setElement(1,x1);

y = editSimData(x,'Signal1','Data',@(x)x*0);
verifyEqual(testCase,y,z)
x2 = x.getElement(2);

x2.Values.sin_t.Data = x2.Values.sin_t.Data*0;
x2.Values.cos_t.Data = x2.Values.cos_t.Data*0;
z = z.setElement(2,x2);

y = editSimData(x,'','Data',@(x)x*0);
verifyEqual(testCase,y,z)
end

function testResample(testCase)
x = testCase.TestData.x;
t1 = 1:2:9;

x1 = x.getElement(1);
x1.Values.sin_t = x1.Values.sin_t.resample(t1);
z = x.setElement(1,x1);

y = editSimData(x,'Signal1.sin_t','',@(ts)ts.resample(t1));
verifyEqual(testCase,y,z)

x1.Values.cos_t = x1.Values.cos_t.resample(t1);
z = x.setElement(1,x1);

y = editSimData(x,'Signal1','',@(ts)ts.resample(t1));
verifyEqual(testCase,y,z)

x2 = x.getElement(2);
x2.Values.sin_t = x2.Values.sin_t.resample(t1);
x2.Values.cos_t = x2.Values.cos_t.resample(t1);
z = z.setElement(2,x2);

y = editSimData(x,'','',@(ts)ts.resample(t1));
verifyEqual(testCase,y,z)
end

function testMultiData(testCase)
x = testCase.TestData.x;
b = -1;

x1 = x.getElement(1);
x2 = x.getElement(2);

y = editSimData([x1,x2],'sin_t','Time',@(t)t+b);

x1.Values.sin_t.Time = x1.Values.sin_t.Time + b;
x2.Values.sin_t.Time = x2.Values.sin_t.Time + b;

verifyEqual(testCase,y,[x1,x2])
end

function testMultiAddress(testCase)
x = testCase.TestData.x;
b = -1;

x1 = x.getElement(1);
x1.Values.sin_t.Time = x1.Values.sin_t.Time + b;
z = x.setElement(1,x1);
x2 = x.getElement(2);
x2.Values.cos_t.Time = x2.Values.cos_t.Time + b;
z = z.setElement(2,x2);

y = editSimData(x,{'Signal1.sin_t','Signal2.cos_t'},'Time',@(t)t+b);
verifyEqual(testCase,y,z)
end

function testEditSignal(testCase)
x = testCase.TestData.x;
x = x.getElement(1);
b = -1;

z = x;
z.Values.sin_t.Time = z.Values.sin_t.Time + b;

y = editSimData(x,'sin_t','Time',@(t)t+b);
verifyEqual(testCase,y,z)

z.Values.cos_t.Time = z.Values.cos_t.Time + b;

y = editSimData(x,'','Time',@(t)t+b);
verifyEqual(testCase,y,z)
end

function testEditStruct(testCase)
x = testCase.TestData.x;
x = x.getElement(1).Values;
b = -1;

z = x;
z.sin_t.Time = z.sin_t.Time + b;

y = editSimData(x,'sin_t','Time',@(t)t+b);
verifyEqual(testCase,y,z)

z.cos_t.Time = z.cos_t.Time + b;

y = editSimData(x,'','Time',@(t)t+b);
verifyEqual(testCase,y,z)
end

function testEditTimeseries(testCase)
x = testCase.TestData.x;
x = x.getElement(1).Values.sin_t;
b = -1;

z = x;
z.Time = z.Time + b;

y = editSimData(x,'','Time',@(t)t+b);
verifyEqual(testCase,y,z)
end
