clc;
close all;
im=imread('final1.jpeg');
imshow(im);
if size(im,3)==3 
    im=rgb2gray(im);
    figure,imshow(im);
end
threshold = graythresh(im); %used escpecially to find the threshold for binarising
i =~imbinarize(im,threshold);
figure,
imshow(i);
i = bwareaopen(i,200); %removes the smaller unwanted details like small circles in car8.jpg
figure,imshow(i);

fid = fopen('text.txt', 'wt');
load templates;
global templates;
num_letters=size(templates,2);
RL=i;
word=[];
w=ocr(im);
woord=w.Text;
while 1
    [FL, RL]=horizonatalSegmentation(RL);
    figure
    imshow(FL)
    imagen=FL;
    n=0;
    spacevector=[];
    RA=FL;
    
    while 1
        [FA ,RA, space]=verticalSegmentation(RA);
        imgChar=imresize(FA,[42 24]);
        n=n+1;
        spacevector(n)=space;
        figure
        imshow(FA);
        letter=TemplateMatching(imgChar,num_letters);
        word=[word letter];
        
        if isempty(RA)
            break;
            
        end
    end
    
  max_space = max(spacevector);
    no_spaces = 0;
     for x= 1:n   %loop to introduce space at requisite locations
       if spacevector(x+no_spaces)> (0.75 * max_space)
          no_spaces = no_spaces + 1;
            for m = x:n
              word(n+x-m+no_spaces)=word(n+x-m+no_spaces-1);
            end
           word(x+no_spaces) = ' ';
           spacevector = [0 spacevector];
       end
     end
   
            
    %fprintf(fid,'%s\n',woord)%Write 'word' in text file (upper)
    % Clear 'word' variable
    word=[ ];
    %*When the sentences finish, breaks the loop
    if isempty(RL)  
        break
    end
end
fprintf(fid,'%s\n',woord)
fclose(fid);
%Open 'text.txt' file
winopen('text.txt')



textLineEntryCellArray = '';
fid = fopen('text.txt');
while ~feof(fid)
      textLineEntry = fgetl(fid);
      textLineEntryUpdated = strrep(textLineEntry, ' ', '%20');
      textLineEntryCellArray=[textLineEntryCellArray textLineEntryUpdated '%0A'];
end 
url2=textLineEntryCellArray;
disp(url2);
url1='https://translate.google.com/#view=home&op=translate&sl=en&tl=kn&text=';
url=[url1 url2];
[stat,h]= web(url);
fclose(fid);





