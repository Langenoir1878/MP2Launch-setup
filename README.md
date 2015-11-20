# MP2Launch-setup
Updated 2015 08:54:07 AM F Nov 20, 2015

Github repo links for MP2:

1. Application repo:
https://github.com/Langenoir1878/MP2Application-setup.git

2. Launch script repo:
https://github.com/Langenoir1878/MP2Launch-setup.git

3. Environment setup repo:
https://github.com/Langenoir1878/MP2Environment-setup.git




Testing Instructions:

Please download the 3 repositories and run the launch.sh 

OR

For simple application testing please run the simpleLaunch.sh



	Params to be passed are in the same sequence for both shell scripts:

	# $1 image-ids
	# $2 count of instances to launch
	# $3 instance-type
	# $4 security-group-ids
	# $5 subnet-id
	# $6 key-name
	# $7 iam-instance-profile


Application Testing:



Please enter ec2...amazonaws.com/index.php in web browser bar 
It will automatically navigate to the login page. 
Follow the simple instructions for gallery testing. 
No need to implement setup.php file.

For Testing the Signed In Subscribers:
The application will automatically subscribe to the user email after successfully logged in.
For Testing non-subscribers/guest:
Please click the "continue as guest" button in the login page.


