#!/bin/bash
#set -x


box_comment()
{
printf "\n****************************************\n"
printf "$1 \n"
printf "****************************************\n\n"
}

#`pwd`=TIDIR;
TIDIR="/m/a1_SJoshi_build3/Common/Tivoli-ITM6"
#"M:\a1_SJoshi_build3\Common\Tivoli-ITM6=TIDIR"
echo $TIDIR;
cd $TIDIR


box_comment "Enter build number, eg BTMATIVMON009...";
read BN;
box_comment "Enter Tiv Mon version number";
read VERNO;
box_comment "Enter defect number, ...";
read DEFT;

export DEFAULT_DEFECT_NO=$DEFT;



rm -rf /c/SitScripts 2>/nul
rm -rf /c/StartScripts 2>/nul


box_comment "Good, now Open the O2_ITM_Situations.xls\n..Click on the Button\nWhen it has finished, click y to continue\n"


#printf "Continuare? (y/n):\n";
read ANSWER;
      if [[ $ANSWER = "y" || $ANSWER = "Y" ]]
      then
	:					      	:
      else
	exit
      fi


#Copy CC Common\Tivoli-ITM6\Scripts\* to C:\SitScripts 
#Copy CC Common\Tivoli-ITM6\ScriptsUA\* to C:\SitScripts
printf "Copy scripts to c:\SitScripts\n";
cp Scripts/* /c/SitScripts
cp -r UAScripts/* /c/SitScripts
pwd


printf "Creating tar file";
cd /c
tar -cf SitScripts${VERNO}.tar SitScripts;
cd $TIDIR
pwd
cp /c/SitScripts${VERNO}.tar SitScripts_RELEASE


pwd
box_comment "Now Open the O2_Deployment_Prod.xls\n..Click on the Button\nWhen it has finished, click y to continue\n"
read ANSWER;
      if [[ $ANSWER = "y" || $ANSWER = "Y" ]]
      then
	:					      	:
      else
	exit
      fi
pwd
cp Scripts/InstallStartScripts.pl /c/StartScripts;
#Zip up C:\StartScripts into a tar file for deployment called StartScriptsProd<verno>.tar.
cd /c
tar -cf StartScriptsProd${VERNO}.tar StartScripts;
cd $TIDIR
pwd
cp /c/StartScriptsProd${VERNO}.tar SitScripts_RELEASE

rm -rf /c/StartScripts 2>/nul

box_comment "Now Open the O2_Deployment_TT.xls\n..Click on the Button\nWhen it has finished, click y to continue\n"
read ANSWER;
      if [[ $ANSWER = "y" || $ANSWER = "Y" ]]
      then
	:					      	:
      else
	exit
      fi
pwd
cp Scripts/InstallStartScripts.pl /c/StartScripts;
#Zip up C:\StartScripts into a tar file for deployment called StartScriptsProd<verno>.tar.
cd /c
tar -cf StartScriptsTT${VERNO}.tar StartScripts;
cd $TIDIR
pwd
cp /c/StartScriptsTT${VERNO}.tar SitScripts_RELEASE




# Add stuff to CC


add_to_CC()
{
box_comment "Consegnare"
pwd
	cd SitScripts_RELEASE;
	cleartool co -c "Adding files for TIVMON version $VERNO" .;
	cleartool mkelem -c "Adding files for TIVMON version $VERNO" SitScripts${VERNO}.tar
	cleartool mkelem -c "Adding files for TIVMON version $VERNO" StartScriptsProd${VERNO}.tar
	cleartool mkelem -c "Adding files for TIVMON version $VERNO" StartScriptsTT${VERNO}.tar
	
	cleartool ci -c "Adding files for TIVMON version $VERNO" . SitScripts${VERNO}.tar StartScriptsProd${VERNO}.tar StartScriptsTT${VERNO}.tar
	
	
	box_comment "Labelling stuff";
	cleartool mklbtype -nc $BN;
	cleartool mklabel -rep $BN SitScripts${VERNO}.tar StartScriptsProd${VERNO}.tar StartScriptsTT${VERNO}.tar . .. ../.. ;
	cd ..
	cd Scripts;
	cleartool mklabel -rep -rec $BN .;
	cd ../UAScripts;
	cleartool mklabel -rec -rep $BN .;
	cd ..
	cleartool mklabel -rep $BN O2_ITM_Situations.xls O2_Deployment_Prod.xls O2_Deployment_TT.xls . ..;
	cleartool lock lbtype:$BN;
	}
	
	add_to_CC
