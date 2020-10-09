#!/QOpenSys/usr/bin/sh
# This line with '#' is a comment, the above line with '#!' is a Shebang, by which the shell knows which shell to use.
# We have used 'sh' shell on the IBM i which is mostly available by default, alternatively one may use 
# /QOpenSys/pkgs/bin/bash (to check if it's available, do a cd /QOpenSys/pkgs/bin/ if there are no errors, bash is 
# available on your IBM i)
# For more information visit - https://www.ibm.com/support/knowledgecenter/ssw_ibm_i_74/rzalf/rzalfpase.htm

# The below line runs our application by navigating to the app.js in the directory structure. 
node /home/ANANDK/currency/app.js 'USD'
