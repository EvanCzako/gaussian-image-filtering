function im_2 = gaussian_lowpass_filter(im_1,high_freq,show_freq_domain,y_over_x_scale_factor)
    
    % Returns a lowpass-filtered version of im_1. Applies a Gaussian filter 
    % to im_1 by acquiring its frequency domain and setting the full-width-
    % at-half-max of the Gaussian filter to the spatial frequency defined
    % by high_freq. Spatial frequency intensity decays as spatial frequency
    % increases according to the filter.
    % By marking boolean input show_freq_domain as true, you can compare 
    % the filtered image to the original image, visualize the filter 
    % window, and compare the filtered frequency domain to the original 
    % frequency domain to better understand the mechanism behind this 
    % filter.
    % If your image corresponds to physical data, you should utilize the 
    % y_over_x_scale_factor input variable, which is the ratio of the
    % physical height of the image to the physical width of the image. If
    % this value is set to 1, the filter assumes the physical height and
    % width of the image are equivalent, even if there are more columns
    % than rows or vice versa.
    % Spatial frequencies are by default defined with respect to the
    % boundaries of the image. If you have a 258x350 image, then a
    % frequency of 1 corresponds to a wavelength of 258 pixels in the
    % y-direction and a wavelength of 350 pixels in the x-direction.
    %
    % The purpose of this function is to provide a smoother filter than the
    % hard-pass filters I provided at: 
    % https://www.mathworks.com/matlabcentral/fileexchange/72682-hard-low-pass-high-pass-and-band-pass-filtering-for-images
    % 
    % The hard filters are good for isolating specific frequencies, but
    % when applied to images that represent more than a simple
    % superposition of waves, they often yield results with wavy artifacts,
    % most likely due to image edges and the discontinuous nature of the
    % filter.
    % This Gaussian filter is less robust for isolating particular 
    % frequencies (as it does not entirely eliminate frequencies outside
    % of those defined by the threshold, instead allowing them to smoothly
    % decay), but is better suited for providing artifact-free filtered
    % images, which are in some contexts (e.g. precision-machining) more 
    % useful.
    %
    % Example 1:
    %
    %     % Apply a Gaussian lowpass filter to image 'trees.tif'.
    %     % Currently the upper frequency limit is set to 10, corresponding to a
    %     % spatial frequency of 10 Hz in both the x- and y-directions.
    %     % Since the dimensions of this image are not equivalent (more columns than
    %     % rows), a spatial frequency of 1 in the x-direction corresponds to a
    %     % wavelength of 350 pixels, whereas a spatial frequency of 1 in the
    %     % y-direction corresponds to a wavelength of 258 pixels. If you know the
    %     % physical dimensions of your image, you should utilize the 
    %     % y_over_x_scale_factor input variable. In this example, if a single pixel
    %     % represented the same amount of physical space in the x- and y-directions
    %     % (e.g. 1mm x 1mm), then the y_over_x_scale factor would be 258/350, since
    %     % the height of the image is 258 mm and the width of the image is 350 mm.
    %     % This ensures that the threshold frequency corresponds to real spatial 
    %     % frequencies as opposed to spatial frequencies defined by the image 
    %     % boundaries.
    % 
    %     pic = imread('trees.tif');
    %     pic_filtered = gaussian_lowpass_filter(pic,10,true,1);
    %
    %
    % See also: gaussian_highpass_filter
    %
    % Evan Czako, 9.17.2019.
    % -------------------------------------------
    


    num_rows = size(im_1,1);
    num_cols = size(im_1,2);
    [X,Y] = meshgrid(1:num_cols,1:num_rows);
    freq_domain = fft2(im_1);
    freq_domain_shifted=fftshift(freq_domain);
    freq_pass_window = ones(size(im_1));
    freq_pass_window_center_x = floor(size(freq_pass_window,2)/2)+1;
    freq_pass_window_center_y = floor(size(freq_pass_window,1)/2)+1;
    gauss_filter = exp(-4*log(2)*(X-freq_pass_window_center_x).^2/(2*high_freq)^2) .* exp(-4*log(2)*(Y-freq_pass_window_center_y).^2/(2*high_freq)^2/y_over_x_scale_factor^2);
    freq_pass_window = freq_pass_window.*gauss_filter;
    windowed_freq_domain_shifted = freq_domain_shifted.*freq_pass_window;
    adjusted_freq_domain = ifftshift(windowed_freq_domain_shifted);
    im_2 = ifft2(adjusted_freq_domain);

    if show_freq_domain
        figure, imagesc(im_1);
        title('Original image');
        figure, imagesc(freq_pass_window);
        title('Filter');
        figure, imagesc(log10(abs(freq_domain_shifted)));
        title('log_1_0(Original frequency domain)');
        figure, imagesc(log10(abs(windowed_freq_domain_shifted)));
        title('log_1_0(Filtered frequency domain)');
        figure, imagesc(abs(freq_domain_shifted));
        title('Original frequency domain');
        figure, imagesc(abs(windowed_freq_domain_shifted));
        title('Filtered frequency domain');
        figure, imagesc(im_2);
        title('Filtered image');
    end
    
end