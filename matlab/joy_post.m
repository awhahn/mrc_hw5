% Create a bag file object with the file name
bag = rosbag('~/mrc_hw5_data/joy.bag');
   
% Display a list of the topics and message types in the bag file
bag.AvailableTopics
   
% Since the messages on topic /odom are of type Odometry,
% let's see some of the attributes of the Odometry
% This helps determine the syntax for extracting data
msg_odom = rosmessage('nav_msgs/Odometry');
showdetails(msg_odom)
   
% Get just the topic we are interested in
bagselect = select(bag,'Topic','/odom');
   
% Create a time series object based on the fields of the turtlesim/Pose
% message we are interested in
ts = timeseries(bagselect,'Pose.Pose.Position.X','Pose.Pose.Position.Y',...
    'Twist.Twist.Linear.X','Twist.Twist.Angular.Z',...
    'Pose.Pose.Orientation.W','Pose.Pose.Orientation.X',...
    'Pose.Pose.Orientation.Y','Pose.Pose.Orientation.Z');

x = ts.data(:,1);
y = ts.data(:,2);

quat = [ts.data(:,5),ts.data(:,6),ts.data(:,7),ts.data(:,8),];
eul = quat2eul(quat);
theta = eul(:,1);
u = ts.data(:,3).*cos(theta);
v = ts.data(:,3).*sin(theta);
ii = 1:10:length(ts.data(:,3));

% The time vector in the timeseries (ts.Time) is "Unix Time"
% which is a bit cumbersome.  Create a time vector that is relative
% to the start of the log file
tt = ts.Time-ts.Time(1);
% Plot the X position vs time
figure();
clf();
plot(x,y)
xlabel('X [m]')
ylabel('Y [m]')
hold on 
plot(x(1),y(1),'g*');
plot(x(end),y(end),'r*');


figure();
clf();
plot(x,y)
xlabel('X [m]')
ylabel('Y [m]')
quiver(x(ii),y(ii),u(ii),v(ii))
hold on;
title('Quiver Plot');
plot(x(1),y(1),'g*');
plot(x(end),y(end),'r*');

figure();
clf();
plot(tt,theta*(180/pi));
hold on;
xlabel('Time [s]')
ylabel('Theta [deg]')
% plot(tt(1),theta(1),'g*');
% plot(tt(end),theta(end),'r*');

figure();
clf();
plot(tt,ts.data(:,3),'.');
xlabel('Time [s]')
ylabel('Linear Velocity');