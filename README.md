# gaussian-image-filtering
Smoother versions of highpass and lowpass filters where spatial frequency thresholds correspond to the FWHM of Gaussian-based filters.

Takes input image, modifies its frequency domain according to upper or lower spatial frequency thresholds, and returns the filtered image. These are Gaussian filters in that the threshold frequencies correspond to the FWHM (full-width-at-half-maximum) of the Gaussian equations defining the filters. The frequencies outside of the threshold smoothly and asymptotically decay to 0.

Compare to the "hard" filters I contributed at: https://www.mathworks.com/matlabcentral/fileexchange/72682-hard-low-pass-high-pass-and-band-pass-filtering-for-images

The hard filters are good for isolating specific frequencies, but when applied to images that represent more than a simple superposition of waves, they often yield results with wavy artifacts, most likely due to image edges and the discontinuous nature of the filter.

This Gaussian filter is less robust for isolating particular frequencies (as it does not entirely eliminate frequencies outside of those defined by the threshold, instead allowing them to smoothly decay), but is better suited for providing artifact-free filtered images, which are in some contexts (e.g. precision-machining) more useful.

This function also includes a scale factor for physical data. This should be utilized any time the height of an image differs physically from its width (e.g. an image that physically represents a 2 mm x 3 mm area).

Please see function description and examples for a more in-depth explanation and demonstration of its use.

[![View Gaussian filtering for images on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/72795-gaussian-filtering-for-images)
