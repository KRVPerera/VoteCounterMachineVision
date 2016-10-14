function [] = HoughTransformVisualization(RGBImage)
adapt = OptimalThresholdedImage(RGBImage);
cannyseg = edge(adapt,'canny');
[H, theta, rho] = hough(cannyseg);
% Find the peak pt in the Hough transform
peak = houghpeaks(H,3);
%% Visualization
imshow(H,[],'XData',theta,'YData',rho,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
plot(theta(peak(:,2)),rho(peak(:,1)),'s','color','white');

end