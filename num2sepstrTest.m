function tests = num2sepstrTest
tests = functiontests(localfunctions);
end

function testGeneric(testCase)
verifyEqual(testCase,num2sepstr(1000),'1,000')
verifyEqual(testCase,num2sepstr(1234.5),'1,234.5')
verifyEqual(testCase,num2sepstr(1234.5,'%.2f'),'1,234.50')
verifyEqual(testCase,num2sepstr(1234.5,'%.4f'),'1,234.5000')
verifyEqual(testCase,num2sepstr(123456789.5,'%.0f'),'123,456,790')
end
function testZero(testCase)
verifyEqual(testCase,num2sepstr(0),'0')
end
function testInteger(testCase)
verifyEqual(testCase,num2sepstr(1),'1')
verifyEqual(testCase,num2sepstr(-1),'-1')
verifyEqual(testCase,num2sepstr(100),'100')
verifyEqual(testCase,num2sepstr(-100),'-100')
end
function testNoCommas(testCase)
verifyEqual(testCase,num2sepstr(0),num2str(0))
verifyEqual(testCase,num2sepstr(1),num2str(1))
verifyEqual(testCase,num2sepstr(pi),num2str(pi))
verifyEqual(testCase,num2sepstr(pi,'%.4f'),num2str(pi,'%.4f'))
verifyEqual(testCase,num2sepstr(pi,'%.8f'),num2str(pi,'%.8f'))
verifyEqual(testCase,num2sepstr(999),num2str(999))
verifyEqual(testCase,num2sepstr(999.99),num2str(999.99))
end
function testFormatSpecfiers(testCase)
verifyEqual(testCase,num2sepstr(1234.6,'%.4f'),'1,234.6000')
verifyEqual(testCase,num2sepstr(1234.6,'%.0f'),'1,235')
verifyEqual(testCase,num2sepstr(1234.6,'%+.4f'),'+1,234.6000')
verifyEqual(testCase,num2sepstr(1234.6,'%10.4f'),'1,234.6000')
verifyEqual(testCase,num2sepstr(1234.6,'%20.4f'),'1,234.6000')
end
function testLongNumbers(testCase)
verifyEqual(testCase,num2sepstr(1234567890123456),'1,234,567,890,123,456')
verifyEqual(testCase,num2sepstr(1234567890123456,'%.0f'),'1,234,567,890,123,456')
verifyEqual(testCase,num2sepstr(12345678901234567890),'1.234567890123457e+19')
% verifyEqual(testCase,num2sepstr(12345678901234567890,'%.0f'),'12,345,678,901,234,567,000')
end
function testScientificNotation(testCase)
verifyEqual(testCase,num2sepstr(126,'%.0g'),num2str(126,'%.0g'))
verifyEqual(testCase,num2sepstr(126,'%.5g'),num2str(126,'%.5g'))
verifyEqual(testCase,num2sepstr(126,'%.0e'),num2str(126,'%.0e'))
verifyEqual(testCase,num2sepstr(126,'%.5e'),num2str(126,'%.5e'))
verifyEqual(testCase,num2sepstr(1235674786,'%.0g'),num2str(1235674786,'%.0g'))
end
function testComplexNumbers(testCase)
verifyEqual(testCase,num2sepstr(sqrt(-1e9),'%.2f'),'0.00+31,622.78i')
verifyEqual(testCase,num2sepstr(1e3*(-pi + exp(1)*1i)),'-3,141.5927+2,718.2818i')
verifyEqual(testCase,num2sepstr(1e3*(-pi + exp(1)*1i),'%.2f'),'-3,141.59+2,718.28i')
end