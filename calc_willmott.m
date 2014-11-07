function wilm = calc_willmott(buoy,model)

bias = calc_bias(buoy,model);
temp1 = abs(model - buoy);
temp2 = abs(model - repmat(mean(buoy),[length(model),1]));
temp3 = abs(buoy - repmat(mean(buoy),[length(model),1]));
wilm = 1.0 - sum(temp1)/sum(temp2 + temp3);