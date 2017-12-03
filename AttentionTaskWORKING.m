%AttentionTask.m%
%%PHILIP J SPELMAN w/ BRANDON L GRAY%%
%%several files need to exist in the cogent toolbox (C:\Cogent2000v1.33\Toolbox\) including
  %% readUSB245.m
  %% writeUSB245.m
  %% config_ftdi.m
  %% config_io.m
  %% USB245.mexw32
  %% USB245.mexw64

  %% GET THE COGENT TOOLBOX:
  %% http://www.vislab.ucl.ac.uk/cogent_2000_terms_and_conditions.php
  %%
  %% USB245 / FTDI & Other resources for downloading the necessary files:
  %% http://apps.usd.edu/coglab/psyc770/USB245.html
  %% http://apps.usd.edu/coglab/psyc770/psyc770_matlab_main.html
  %% You can also contact the first author of this script

clear all;

%%%%%% THE FTDI section is for use with the FTDI chip (UM245R or some other chip) and a button box / breadboard setup %%%%%%%%
%%%%%% YOU CAN MODIFY THE CODE TO MATCH YOUR HARDWARE SETUP                                                           %%%%%%%%

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


%%%% CONFIGURE THE KEYBOARD INPUT %%%%

config_keyboard( 100, 5, 'nonexclusive'); %config_keyboard ( 
	%number of key events, time b/t reads, exclusive/not)

%%%% CONFIGURE THE DISPLAY %%%%
config_display(0,3);
%config_display( mode, resolution, background, foreground, fontname, fontsize, nbuffers, nbits, scale); 


%{
NOTES ON DISPLAY CONFIGURATION FROM THE COGENT TOOLBOX
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

%{  
SOME NOTES ON THE DATA
1. For Location 
    1 = TOP
    2 = BOTTOM
2. Direction
    1 = Left
    2 = Right
    3 = Left Incongruent
    4 = Right Incongruent

3. Cue word
    "pop" - this is filled in with the wordlist

4. Cue Location
    1 = TOP
    2 = BOTTOM
    3 = CENTER

5. Response
    Key pressed by the user

6. Reaction Time
   Keydown time - Stimulus display time


7. Word Valences (+/-,arousal)
   
  1. 'positive', 'low';
  2. 'positive', 'high';
  3. 'negative', 'low';
  4. 'negative', 'high';
  5. 'neutral', 'neutral';
  6. 'no cue', 'no cue'

%} 

start_cogent;
	% put a fixation point in the middle of screen buffer 2
fixationSymbol = '+';
preparestring(fixationSymbol,2); 
drawpict(2); %this will draw the fixation symbol
wait(1000)
clearpict(2);

    %% PRESENT THE INSTRUCTIONS TO THE USER 
yInstructionsTop = 100; %Y coordinate for the top of the instructions
ySpace = 100; %spacing of the instruction lines

preparestring('=>  =>  =>  =>  =>',2,0,yInstructionsTop + ySpace);
preparestring('Decide what direction the MIDDLE arrow is pointing',2,0,yInstructionsTop);
preparestring('use "Z" or LEFT for a MIDDLE arrow like this <=',2,0,yInstructionsTop - ySpace);
preparestring('use "M" or RIGHT for a MIDDLE arrow like this =>',2,0,yInstructionsTop - ySpace*2);
preparestring('SPACE to continue | press B to use button box',2,0,yInstructionsTop - ySpace*3);
drawpict(2);

%%SET THE INPUT inputType - For KEYBOARD input press any key other than 'B'
%%Press 'B' to use input from the FTDI chip 
%the M key is 13
%the Z key is 26

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

clearpict(2);

xTop = 0;
xBottom = 0;
yTop = 200;
yBottom = -200;


%%  SET THE CUE LOCATION with: round(0+rand(1)*(2 - 1)); %this will be 0, 1, or 2;
trials(1).cueLocation = 0;
if trials(1).cueLocation == 0
  tempLocation = round(1+rand(1)*(2 - 1)); %this will be 1, or 2
    switch tempLocation
      case 1 %Y-COORDINATE WILL be the bottom
        trials(1).location = yBottom;
      case 2
        trials(1).location = yTop;
    end
end
  %trials(1).location = round(1+rand(1)*(2 - 0)); %this will be 1 or 2 

clearpict(1);

  %%Draw the fixation 
drawpict(2);

rts = -1;
times = -1;
keys = -1;
clearkeys;
key = -1;

%NOW TO DISPLAY ARROWS

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %% THIS IS WHERE THE TASK IS GOING TO START!  %%
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% HOW MANY TRIALS WILL BE PRESENTED?
numTrials = 4;

valenceArray = {
  'positive', 'low';
  'positive', 'high';
  'negative', 'low';
  'negative', 'high';
  'neutral', 'neutral';
  'no cue', 'no cue'
};

%%%% THIS IS WHERE YOU CAN PUT IN YOUR OWN WORDS AND CORRESPONDING VALENCES %%%%
%% BUILD THE WORD LIST
%to randomly select a word: words(round(1+rand(1)*(11 - 1)))

wordValenceArray = {
  'Afraid',4;
  'Meaningless',3;
  'Triumphant',2;
  'Clarity',1;
  'Stamp',5;
  'Mutilated',4;
  'Abandoned',3;
  'Ecstasy',2;
  'Safe',1;
  'Hammer',5;
  '',6;
};  

%% BUILD THE ARROW LIST
arrows = {'=>  =>  <=  =>  =>', '<=  <=  <=  <=  <=', '=>  =>  =>  =>  =>', '<=  <=  =>  <=  <='};

%1 is LEFT, 2 is LEFT, 3 is RIGHT, 4 is RIGHT
%to randomly select an arrow sequence: arrows(round(1+rand(1)*(4 - 1)));

%%RANDOMIZATION SETUP for CUE location
for i = 1:numTrials  
      tempLocation = round(0+rand(1)*(2 - 1)); %this will be 0, 1, or 2
        switch tempLocation
          case 0
            trials(i).cueLocation = 0;
          case 1
            trials(i).cueLocation = yBottom;
          case 2
            trials(i).cueLocation = yTop;
        end
end

%%RANDOMIZATION SETUP FOR ARROW LOCATION
for i = 1:numTrials  
    if trials(i).cueLocation == 0
      tempLocation = round(1+rand(1)*(2 - 1)); %this will be 1, or 2
        switch tempLocation
          case 1
            trials(i).location = yBottom;
          case 2
            trials(i).location = yTop;
        end
    else 
      trials(i).location = trials(i).cueLocation;
    end
end

%% STATE WHICH FILE WILL BE USED TO SAVE THE TRIAL DATA
    fid = fopen('reactionTime.txt','a');
    fprintf(fid, '\nNEW ROUND OF TRIALS\n');

%% PRINT THE DATA HEADERS INTO THE OUTPUT FILE
fprintf(fid, 'Arrow_Location, Arrow_Sequence, Cue_Word, Cue_Valence, Cue_Location, Arrow_Direction, User_Response, Correct_Incorrect, Reaction_Time\n');

%Open the loop for the trials
for i = 1:numTrials

    
    %  FIXATION
  preparestring('+',1); 
  drawpict(1); %this will draw the . as crosshair 
  wait(400);
  clearpict(1);

  %%RANDOMLY ASSIGN A WORD FROM THE WORD LIST
    wordSwordSelect = round(1+rand(1)*(11 - 1));
    trials(i).cue = wordValenceArray(wordSwordSelect);
    trials(i).valence = wordValenceArray(wordSwordSelect,2);


 %%RANDOMLY ASSIGN AN ARROW PRESENTATION FROM THE ARROW options
    arrowSelection = round(1+rand(1)*(4 - 1)); %this finds the arrowSelection NUMBER, not the string
    switch arrowSelection
      case 1 %LEFT
        trials(i).arrowDirection = 1;
      case 2 %LEFT
        trials(i).arrowDirection = 1;
      case 3 %RIGHT
        trials(i).arrowDirection = 2;
      case 4 %RIGHT
        trials(i).arrowDirection = 2;
    end

  %% after recording the ARROW DIRECTION (Left/Right) - THIS WILL GET THE STRING of ARROWS
    trials(i).arrowSequence = arrows(arrowSelection);

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
    
    rt = -1; %if your rt is -1 in the data then an INVALID key was pressed
    %% WAIT FOR A RESPONSE


          %%%% THIS IS THE INPUT SECTION %%%%

  switch inputType
        %%%%%% BUTTON BOX CODE %%%%%%
    case 1
      writeUSB245(offDB);         %NO BUTTONS PRESSED
      while readUSB245 == 15      %do nothing while waiting for a button
      end
                      %% A BUTTON GETS PRESSED || ASSIGN REACTION TIME 
      rt = time - displayTime;
      fprintf('the rt was: %d\n',rt);

        %% SAVE THE rt
      trials(i).rt = rt;               

        %% GET THE RAW RESPONSE   %A BUTTON WAS PRESSED
        %% LEFT button wire goes to DB1 - DB1 reads 0 when left button pressed
        %% RIGHT button wire goes to DB0 - DB0 reads 0 when left button pressed
      response = readUSB245;
      fprintf('a button was pressed! | readUSB245 = %d\n',response);
      switch response
          case 13 %LEFT
              trials(i).response = 1; %left
              outText = 'LEFT BUTTON';
          case 14 %RIGHT
              trials(i).response = 2; %right
              outText = 'RIGHT BUTTON';
          case 12 %BOTH
              trials(i).response = -1; %BOTH
              outText = 'seriously?';
          otherwise %ERROR
              trials(i).response = -99; %invalid response
              outText = 'ERROR';
      end
      fprintf('You pressed: %s\n',outText);
      while readUSB245 ~= 15      %wait for no buttons to be pressed
      end
      clearpict(3); 



        %% KEYBOARD INPUT CODE %%
    case 2
        waitkeydown(inf);
        [key, t, n ] = getkeydown;
        
        %%TESTING - Enable the line below to have this output to the MATLAB console
        %fprintf('key: %d\nt: %d\nn: %d\n',key,t,n);
        %%END TESTING

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

      clearpict(3);
      %COMPUTE IF THE ANSWER WAS CORRECT 
      %[code forthcoming]

  end
  fprintf('trials(i).arrowDirection: %d\ntrials(i).response: %d\n', trials(i).arrowDirection, trials(i).response);
  if (trials(i).arrowDirection - trials(i).response) == 0
    trials(i).correct = 1;
  else
    trials(i).correct = 0;
  end
  fprintf(fid, '%d, %s, %s, %d, %d, %d, %d, %d, %d\n', trials(i).location, trials(i).arrowSequence{1}, trials(i).cue{1}, trials(i).valence{1}, trials(i).cueLocation, trials(i).arrowDirection, trials(i).response, trials(i).correct, trials(i).rt);
  wait(400);
    %%BEGIN THE NEXT TRIAL
  i = i+1;
end
                          %%%%%%%%%%%%%%%%%%%
                          %% END OF trials %%
                          %%%%%%%%%%%%%%%%%%%

fclose('all');

%% SAY GOODBYE
preparestring('ALL DONE',2);
drawpict(2);
wait(500);
clearpict(2);

stop_cogent;
stop_cogent;