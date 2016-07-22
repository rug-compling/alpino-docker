@ECHO OFF

SETLOCAL EnableExtensions EnableDelayedExpansion

IF .%1==. (
	ECHO Usage: %0 workdir [command [arg...]]
	GOTO:EOF
)

SET dir="%~f1"

SET s=0
SET args=
FOR %%a IN (%*) DO (
	IF !s!==1 SET args=!args! %%a
	SET s=1
)

SET ok=0
PUSHD %dir% 2> NUL && POPD && SET ok=1
IF %ok%==0 (
	ECHO Directory not found: %dir%
	GOTO:EOF
)

CALL :dirfix "%dir%"

ECHO ON
docker run --rm -i -t -v "%udir%:/work/data" rugcompling/alpino:latest %args%
@ECHO OFF

GOTO:EOF


:dirfix
REM verander "C:\My path\My file" -> "/c/My path/My file"
REM resultaat in %udir%
SET t=%*
SET t=%t:"=%
FOR /F "tokens=1* delims=:" %%a IN ("%t%") DO (
	SET udir=/%%a
	SET t=%%b
)
CALL :LoCase udir
SET udir=%udir%%t:\=/%
GOTO:EOF


:LoCase
REM Subroutine to convert a variable VALUE to all lower case.
REM The argument for this subroutine is the variable NAME.
FOR %%i IN ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i" "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r" "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z") DO CALL SET "%1=%%%1:%%~i%%"
GOTO:EOF
