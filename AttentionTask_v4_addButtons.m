%BGrayTask.m%
%%PHIL SPELMAN%%
%%several files need to exist in the cogent toolbox (C:\Cogent2000v1.33\Toolbox\) including
  %% readUSB245.m
  %% writeUSB245.m
  %% config_ftdi.m
  %% config_io.m
  %% USB245.mexw32
  %% USB245.mexw64


%this is written in the NEW BRANCH
% This is supposed to test the reaction time from a keyboard input
clear all;
%then it will test the ability to capture a reaction time from a screen
%that shifts at a specific time

%config_data ( 'reactionTimeData1.dat' );
%config_log('reactionTest1.log');
%config_results( 'reactionResults1.res' );

config_ftdi;

offDB = 0;
onDB4 = 16;
onDB5 = 32;
onDB45 = 48;
onDB6 = 64;
onDB46 = 80;
onDB56 = 96;
onDB456 = 112;
onDB7 = 128;
onDB47 = 144;
onDB57 = 160;
onDB457 = 176;
onDB67 = 192;
onDB467 = 208;
onDB567 = 224;
onDB4567 = 240;

config_keyboard( 100, 5, 'nonexclusive'); %config_keyboard ( 
	%number of key events, time b/t reads, exclusive/not)
config_display(0,3);
%config_display( mode, resolution, background, foreground, fontname, fontsize, nbuffers, nbits, scale); 
%{
mode  - window mode ( 0=window, 1=full screen ) 
resolution - screen resolution (1=640x480, 2=800x600,    3=1024x768, 4=1152x864, 5=1280x1024, 6=1600x1200) 
background - background colour ( [red,green,blue] or palette index ) 
foreground - foreground colour ( [red,green,blue] or palette index ) 
fontname  - name of font, 
fontsize  - size of font, 
nbuffers - number of offscreen buffers 
nbits - number of bits per pixel (8=palette mode, 16, 24, 32 or 0 where 0 selects the maximum possible bits per pixel out of 16, 24 or 32) 
scale - horizontal size of screen in (visual degrees)
%}

%config_display( 1, 1, [0 0 0], [1 1 1], 'Arial', 25, 4, 8 )
    

start_cogent;
	% put a fixation point in the middle of screen buffer 2
preparestring('.',2); 
drawpict(2); %this will draw the . as crosshair 
wait(1000)
clearpict(2);

    %% PRESENT THE INSTRUCTIONS TO THE USER 
yInstructionsTop = 100;
ySpace = 100;

preparestring('=>  =>  =>  =>  =>',2,0,yInstructionsTop + ySpace);
preparestring('Decide what direction the MIDDLE arrow is pointing',2,0,yInstructionsTop);
preparestring('use "Z" or LEFT for a MIDDLE arrow like this <=',2,0,yInstructionsTop - ySpace);
preparestring('use "M" or RIGHT for a MIDDLE arrow like this =>',2,0,yInstructionsTop - ySpace*2);
preparestring('press B to use the button box',2,0,yInstructionsTop - ySpace*3);
drawpict(2);

%SET THE INPUT inputType
waitkeydown(inf);
[key, t, n ] = getkeydown;
switch key
  case 2
    inputType = 1;
    fprintf('Input from BUTTONS\n');
  otherwise
    inputType = 2;
    fprintf('Input from keyboard\n'); 
end


pause;
clearpict(2);




%{
1. For Location 
    1 = TOP
    2 = BOTTOM
2. Direction
    1 = Left
    2 = Right
    3 = Left Incongruent
    4 = Right Incongruent

3. Cue word
    "poop"

4. Cue Location
    1 = TOP
    2 = BOTTOM
    3 = CENTER

5. Response
    Key pressed by the user

6. Reaction Time
   Keydown time - Stimulus display time

%}


% testArray = [
%     1 1 'pop' 1 5 6
%     2 2 'pop' 2 0 0
%     1 3 'afraid' 3 0 0
%     2 4 'meaningless' 1 0 6
%     1 1 'triumph' 2 0 0
%     2 2 'clarity' 3 0 0
%     1 3 'stamp' 1 0 0
%     2 4 'mutilate' 2 0 0
%     1 1 'ecstacy' 3 0 0
%     2 2 ' ' 1 0 0];

%  trials(1).cueLocation = round(0+rand(1)*(2 - 1)); %this will be 0, 1, or 2;
  trials(1).cueLocation = 0;
if trials(1).cueLocation == 0
  tempLocation = round(1+rand(1)*(2 - 1)); %this will be 1, or 2
    switch tempLocation
      case 1
        trials(1).location = -200;
      case 2
        trials(1).location = 200;
    end
end
  %trials(1).location = round(1+rand(1)*(2 - 0)); %this will be 1 or 2 

  trials(1).arrowSequence = '';
  trials(1).cue = 'poo';
  trials(1).response = 0.0;
  trials(1).rt = 0.0;
  trials(2).location = 2;
  trials(2).arrowSequence = '';
  trials(2).cue = 'goodness';
  trials(2).cueLocation = 2;
  trials(2).response = 0.0;
  trials(2).rt = 0.0;
  trials(3).location = 1;
  trials(3).arrowSequence = '';
  trials(3).cue = 'abandon';
  trials(3).cueLocation = 1;
  trials(3).response = 0.0;
  trials(3).rt = 0.0;
  trials(4).location = 2;
  trials(4).arrowSequence = '';
  trials(4).cue = 'bad';
  trials(4).cueLocation = 2;
  trials(4).response = 0.0;
  trials(4).rt = 0.0;

clearpict(1);

xTop = 0;
yTop = 200;
xBottom = 0;
yBottom = -200;


  %%KEYBOARD INPUT FEATURE

%Dont forget: t = drawpict(1) will store the time of display into t, this
%can then be saved into a file for reaction time comparison
%Read from the keyboard
drawpict(2);

rts = -1;
times = -1;
keys = -1;
%[key, t, n] = getkeydown;
clearkeys;
key = -1;
cycle = 0;
cycles = 0;

%the M key is 13
%the Z key is 26

% loopFinish = 0;
% while loopFinish == 0
%     clearpict(2);
%     preparestring('PRESS Z (left button), or M (right button)',2);
%     time = drawpict(2);
%     waitkeydown(inf);
%     [key, t, n ] = getkeydown;
%     if key == 1 || key == 13 || key == 26
%         loopFinish = loopFinish + 1;
%     end
%     
%     times = [times, time];
%     keys = [keys, key];
%     cycles = [cycles, cycle, time, key]
%     %wait(200);
%     clearpict(2);
%     cycle = cycle + 1;
% end
% 
% switch key %this will set the userResponse based on the key
%     case 1
%         userResponse = 'A';
%     case 13
%         userResponse = 'M';
%     case 26
%         userResponse = 'Z';
%     otherwise
%         disp('Nothing');
% end
% 
% preparestring('KEY PRESSED WAS:',1,xTop,yTop);
% preparestring(userResponse,1,xBottom,yBottom);
% drawpict(1);
% wait(1000);
% clearpict(1);

%NOW TO DISPLAY ARROWS
 
%   randAssignment = round(randMin+rand(1,numTrials)*(randMax - randMin));


      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %% THIS IS WHERE THE TASK IS GOING TO START! **********************************
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%the number needs to be uint8 to make matlab use it as an integer
 %generate the random presentation of arrows

    fid = fopen('reactionTime.txt','a');
    fprintf(fid, 'NEW ROUND OF TRIALS\n');

%% BUILD THE WORD LIST
%to randomly select a word: words(round(1+rand(1)*(11 - 1)))
words = {'Afraid','Meaningless','Triumphant','Clarity','Stamp','Mutilated','Abandoned','Ecstasy','Safe','Hammer',''};

%% BUILD THE ARROW LIST
arrows = {'=>  =>  <=  =>  =>', '<=  <=  <=  <=  <=', '=>  =>  =>  =>  =>', '<=  <=  =>  <=  <='};

%1 is LEFT, 2 is LEFT, 3 is RIGHT, 4 is RIGHT
%to randomly select an arrow sequence: arrows(round(1+rand(1)*(4 - 1)));


numTrials = uint8(4);
%arrows(1,numTrials) = 0


%%RANDOMIZATION SETUP for CUE location
for i = 1:numTrials  
      tempLocation = round(0+rand(1)*(2 - 1)); %this will be 0, 1, or 2
        switch tempLocation
          case 0
            trials(i).cueLocation = 0;
          case 1
            trials(i).cueLocation = -200;
          case 2
            trials(i).cueLocation = 200;
        end
end

%%RANDOMIZATION SETUP FOR ARROW LOCATION
for i = 1:numTrials  
    if trials(i).cueLocation == 0
      tempLocation = round(1+rand(1)*(2 - 1)); %this will be 1, or 2
        switch tempLocation
          case 1
            trials(i).location = -200;
          case 2
            trials(i).location = 200;
        end
    else 
      trials(i).location = trials(i).cueLocation;
    end
end
tic;
toc;

%Open the loop for the trials (there are 10 trials in the real version)
for i = 1:numTrials

    
    %  FIXATION
  preparestring('+',1); 
  drawpict(1); %this will draw the . as crosshair 
  wait(400);
  clearpict(1);

  %%RANDOMLY ASSIGN A WORD FROM THE WORD LIST
    trials(i).cue = words(round(1+rand(1)*(11 - 1)));

 %%RANDOMLY ASSIGN AN ARROW PRESENTATION FROM THE ARROW options
    arrowSelection = round(1+rand(1)*(4 - 1)); %this finds the arrowSelection NUMBER, not the string
    switch arrowSelection
      case 1
        trials(i).arrowDirection = 1;
      case 2
        trials(i).arrowDirection = 1;
      case 3
        trials(i).arrowDirection = 2;
      case 4
        trials(i).arrowDirection = 2;
    end

  %% after recording the ARROW DIRECTION (Left/Right) - THIS WILL GET THE STRING of ARROWS
    trials(i).arrowSequence = arrows(arrowSelection);

             %%%%%%%%testing%%%%%%%%%% 

             %%%%%%%%% END TESTING %%%%%%%%%%
  

    %% PRESENT A CUE SLIDE in buffer 2
      preparestring(trials(i).cue{1}, 2, 0, trials(i).cueLocation);
      drawpict(2);
      wait(1000);
      clearpict(2);

    %% DISPLAY FIXATION POINT AGAIN
      drawpict(1); 
      wait(400);
      clearpict(1);

    %% DISPLAY THE ARROWS IN BUFFER 3
     % preparestring([ARROW COMBO FROM trials],3,0, [ARROW LOCATION from trials]);
      preparestring(trials(i).arrowSequence{1},3,0, trials(i).location);

    %% RECORD THE TIME THE PIC WAS DISPLAYED 
      displayTime = drawpict(3);
          % start the timer!
      tic;
    rt = -1; %if your rt is -1 then an INVALID key was pressed
    %% WAIT FOR A RESPONSE
      

  switch inputType
  %%INSERT THE BUTTON BOX CODE
    case 1
      writeUSB245(offDB);         %NO BUTTONS PRESSED
      while readUSB245 == 15      %do nothing while waiting for a button
      end
                      %% A BUTTON GETS PRESSED || ASSIGN REACTION TIME 
      rt = toc - displayTime;
      fprintf('the rt was: %d',rt);

        %% SAVE THE rt
      trials(i).rt = rt;               

        %% GET THE RAW RESPONSE   %A BUTTON WAS PRESSED
      response = readUSB245;
      fprintf('a button was pressed! | readUSB245 = %d\n',response);
      switch response
          case 13 %LEFT
%               responses = [responses,1];
              trials(i).response = 2; %left
              outText = 'LEFT BUTTON';
          case 14 %RIGHT
%               responses = [responses,2];
              trials(i).response = 1; %right
              outText = 'RIGHT BUTTON';
          case 12 %BOTH
%               responses = [responses,-1];
              trials(i).response = -1; %BOTH
              outText = 'piss off';
          otherwise %ERROR
%               responses = [responses,-99];
              trials(i).response = -99; %invalid response
              outText = 'ERROR';
      end
      fprintf('You pressed: %s\n',outText);
      while readUSB245 ~= 15      %wait for no buttons to be pressed
      end
      clearpict(3); 

    case 2
        waitkeydown(inf);
        [key, t, n ] = getkeydown;
        if key == 1 || key == 13 || key == 26
          %ASSIGN REACTION TIME 
            rt = t - displayTime;
        end
        clearpict(3);
      %% SAVE THE RESPONSES

        trials(i).rt = rt;
        switch key
          case 13
            trials(i).response = 2; %left
          case 26
            trials(i).response = 1; %right
          otherwise
            trials(i).response = -99; %invalid response
        end

        %trials(i).response = key;
        keys = [keys, key];
        cycles = [cycles, cycle, time, key]

      clearpict(3);
      %COMPUTE IF THE ANSWER WAS CORRECT 
      %[code forthcoming]

        fprintf(fid, '%d, %s, %s, %d, %d, %d, %d\n', trials(i).location, trials(i).arrowSequence{1}, trials(i).cue{1}, trials(i).cueLocation, trials(i).arrowDirection, trials(i).response, trials(i).rt);
        wait(400);
    %%BEGIN THE NEXT TRIAL
      i = i+1;
  end
end
                          %%%%%%%%%%%%%%%%%%%
                          %% END OF trials %%
                          %%%%%%%%%%%%%%%%%%%

fclose('all');

%% SAY GOODBYE
preparestring('ALL DONE',2);
drawpict(2);
pause;
clearpict(2);


%% OUTPUT TO FILE

%exists('filename.txt','file')  -- this will test if the file already
%exists

%{
  trials(1).location = 1; %ARROW LOCATION
  trials(1).arrowSequence = '';
  trials(1).cue = 'poo'; %THE CUE WORDS
  trials(1).cueLocation = 1; %CUE LOCATION
  trials(1).response = 0.0;
  trials(1).rt = 0.0;
%}

%arrowLocation (number), 
%arrowDirection (string), 
%cue word (string), 
%cue location (number), 
%response (number), 
%reactionTime (number)
%arrow direction (number)


%%order = [1, 5, 10, 3, 5] this is a random order array, the numbers will
%%refer to which picture will be shown

%loadpict(mypicts{order(i)}, 1) this is for calling the images

%    t = drawpict(i);
 %   preparestring(i,i);







 %%%%%%%%%%%% NOTES %%%%%%%%%

  %%WAIT FOR RESPONSE
%   loopFinish = 0;
%   while loopFinish == 0
%       %clearpict(2);
%       %preparestring('testing PRESS Z, or M',3,0,0);
%       %time = drawpict(2);
%       waitkeydown(inf);
%       [key, t, n ] = getkeydown;
%       if key == 1 || key == 13 || key == 26
%         %ASSIGN REACTION TIME 
%           rt = t - displayTime;
%           loopFinish = loopFinish + 1;
%       end
%       
%       times = [times, time];
%       keys = [keys, key];
%       cycles = [cycles, cycle, time, key]
%       %wait(200);
%       cycle = cycle + 1;
%   end
% 
%   %% EVALUATE THE RESPONSE
% 
%     switch key %this will set the userResponse based on the key
%         case 1
%             userResponse = 'A';
%         case 13
%             userResponse = 'M';
%         case 26
%             userResponse = 'Z';
%         otherwise
%             disp('Nothing');
%     end
% 
%   clearpict(3);

%    switch arrows(i)
%        case 1
%            preparestring(arrowString0,1,xTop,yTop);
%        case 2
%            preparestring(arrowString1,1,xTop,yTop);
%        case 3
%            preparestring(arrowString2,1,xTop,yTop);
%        case 4
%            preparestring(arrowString0,1,xTop,yTop);
%        otherwise
%            preparestring('NONE',1,xTop,yTop);
%    end
% wait(1000);
% clearpict(1);
%     loopFinish = 0;
%     while loopFinish == 0
% %         clearpict(2);
% %         preparestring('PRESS Z, or M',2);
%         time = drawpict(1);
%         waitkeydown(inf);
%         [key, t, n ] = getkeydown;
%         if key == 1 | key == 13 | key == 26
%             loopFinish = 1;
%         end
% 
%         times = [times, time];
%         keys = [keys, key];
%         cycles = [cycles, cycle, time, key]
%         %wait(200);
%         clearpict(2);
%         cycle = cycle + 1;
%     end
% 
%     switch key
%         case 1
%             userResponse = 'A';
%         case 13
%             userResponse = 'M';
%         case 26
%             userResponse = 'Z';
%         otherwise
%             disp('Nothing');
%     end
%end

           

%%END KEYBOARD INPUT

stop_cogent;
stop_cogent;