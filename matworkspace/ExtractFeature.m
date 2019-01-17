%时域 频域特征提取
function [feature] = ExtractFeature(time_series)

a = mean(time_series);
b = std(time_series);
c = max(time_series);
d = min(time_series);
e = quantile(time_series,3);
f = skewness(time_series);
g = kurtosis(time_series);
%h = zero_crossing_rate(time_series);
i = sqrt(sumsqr(time_series(:,1)));

input = time_series;
fft_abs = abs(fft(input));
fft_abs = fft_abs(1:floor(end/2) + 1);
fft_abs(2:end-1) = 2*fft_abs(2:end-1);
sum_fft_abs = sum(fft_abs);
f_i = linspace(0,50,101);
f_i = f_i';
spectral_centroid = sum(f_i .* fft_abs) / sum_fft_abs;
normalized_spectrum = fft_abs ./ sum_fft_abs;
spectral_entropy = sum(normalized_spectrum .* log2(normalized_spectrum));
spectral_spread = sqrt(sum((f_i - ones(size(f_i))*spectral_centroid).^2 .* normalized_spectrum));
spectral_skewness = sum((f_i - ones(size(f_i))*spectral_centroid).^3 .* normalized_spectrum)/(spectral_spread.^3);
spectral_kurtosis = sum((f_i - ones(size(f_i))*spectral_centroid).^4 .* normalized_spectrum)/(spectral_spread.^4);
spectral_flatness = ((prod(fft_abs))^(1/101))/(sum_fft_abs / 101);

feature = [a,b,c,d,e,f,g,i,spectral_centroid,normalized_spectrum,spectral_entropy,spectral_spread,spectral_skewness,spectral_kurtosis,spectral_flatness];