%BGrayTask.m%
%%PHIL SPELMAN%%
%this is written in the NEW BRANCH
% This is supposed to test the reaction time from a keyboard input
clear all;
%then it will test the ability to capture a reaction time from a screen
%that shifts at a specific time

%reaction1.m by Phil Spelman


%config_data ( 'reactionTimeData1.dat' );
config_log('reactionTest1.log');
config_results( 'reactionResults1.res' );
config_keyboard( 100, 5, 'nonexclusive'); %config_keyboard ( 
	%number of key events, time b/t reads, exclusive/not)
config_display(0,2);
%config_display( 1, 1, [0 0 0], [1 1 1], 'Arial', 25, 4, 8 )

arrows1 = '-> -> -> -> ->';
arrows2 = '=> => => => =>';
%        //There are 4 types of arrows that can be retrieved

selection = 3;
arrowString0 = '-> -> -> -> ->'
arrowString1 = '-> -> <- -> ->';
arrowString2 = '<- <- -> <- <-';
arrowString3 = '<- <- <- <- <-';

 
if selection == 0 
    arrowString = '-> -> -> -> ->';          
    else if selection == 1
        arrowString = '-> -> <- -> ->';
        else if selection == 2
            arrowString = '<- <- -> <- <-';
            else if selection ==3 
                arrowString = '<- <- <- <- <-';
                end
            end
        end
end
    

start_cogent;
	% put a fixation point in the middle of screen buffer 2
preparestring('.',2); 
drawpict(2); %this will draw the . as crosshair 
wait(1000)
clearpict(2);

y = -200;
x = -200;
incrementXBy = 30;
incrementYBy = 30;
%preparestring('You are going to do some stuff...',1); %test display of string
%THIS WILL CYCLE THROUGH X,Y COORDINATES AND DISPLAY THEM ON THE SCREEN FOR
%REFERENCE
for i = 1:10
    coordx = num2str(x);
    coordy = num2str(y);
    out = [coordx ' , ' coordy];
    %int2str(x);
    %coordy = int2str(y);
    %coords = coordx + coordy;
    coords = 'poop';
    %preparestring(arrows1,1,20,30); %test display of string
    preparestring(out, 1, x,y);
    drawpict(1);
    %wait(100);    
    x = x+incrementXBy;
    y = y+incrementYBy;
end
wait (500);
clearpict(1);

xTop = 0;
yTop = 100;
xBottom = 0;
yBottom = -100;

preparestring('this is text above',1,xTop,yTop);
preparestring('this is text below',1,xBottom,yBottom);
drawpict(1);
wait(500);
preparestring(arrowString0,1);
drawpict(1);
wait(500);
clearpict(1);

%%KEYBOARD INPUT FEATURE

%Dont forget: t = drawpict(1) will store the time of display into t, this
%can then be saved into a file for reaction time comparison
%Read from the keyboard
drawpict(2);

times = -1;
keys = -1;
%[key, t, n] = getkeydown;
clearkeys;
key = -1;
cycle = 0;
cycles = 0;

%the M key is 13
%the Z key is 26
loopFinish = 0;
while loopFinish == 0
    clearpict(2);
    preparestring('PRESS A, Z, or M',2);
    time = drawpict(2);
    waitkeydown(inf);
    [key, t, n ] = getkeydown;
    if key == 1 | key == 13 | key == 26
        loopFinish = 1;
    end
    
    times = [times, time];
    keys = [keys, key];
    cycles = [cycles, cycle, time, key]
    %wait(200);
    clearpict(2);
    cycle = cycle + 1;
end

switch key
    case 1
        userResponse = 'A';
    case 13
        userResponse = 'M';
    case 26
        userResponse = 'Z';
    otherwise
        disp('Nothing');
end

preparestring('KEY PRESSED WAS:',1,xTop,yTop);
preparestring(userResponse,1,xBottom,yBottom);
drawpict(1);
wait(500);
pause();
clearpict(1);



%%END KEYBOARD INPUT

%cgpencol(1,5,0);
%cgrect(0,0,20,20);
%wait(2000);
%exists('filename.txt','file')  -- this will test if the file already
%exists

fid = fopen('reactionTime.txt','a')


%COULD USE RANDPERM to get a random permutation 

%%order = [1, 5, 10, 3, 5] this is a random order array, the numbers will
%%refer to which picture will be shown

%loadpict(mypicts{order(i)}, 1) this is for calling the images

%    t = drawpict(i);
 %   preparestring(i,i);

stop_cogent;
