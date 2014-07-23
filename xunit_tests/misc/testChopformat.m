function testChopformat

% this number has some rounding and some cases of '100' where log10() is 2 but textual nSigDig is 3
v1 = 100.0763;
strL = { '100', '100', '100', '100.1', '100.08', '100.076', '100.0763', '100.07630' };

for iV = 1:8
    tStr = chopformat(v1, iV);
    assertEqual(tStr, strL{iV})
end


v1 = 50.51;
strL = { '50', '51', '50.5', '50.51', '50.510' };

for iV = 1:length(strL)
    tStr = chopformat(v1, iV);
    assertEqual(tStr, strL{iV})
end

% neg num; some repeated rounding
v1 = -67.6098;
strL = { '-70', '-68', '-67.6', '-67.61', '-67.610', '-67.6098', '-67.60980' };

for iV = 1:length(strL)
    tStr = chopformat(v1, iV);
    assertEqual(tStr, strL{iV})
end

