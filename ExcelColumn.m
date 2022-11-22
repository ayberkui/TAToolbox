
function N = ExcelColumn(n)
alphabets = 'A':'Z';
if isnumeric(n) == 1 && n > 0 && n-floor(n) == 0
i = 1;
while n > polyval([ones([1,i-1]),0],26)
if n-polyval([ones([1,i]),0],26) < 1
for j = 1:i
if mod(n,26^j) == 0
Ninv(j) = alphabets(26);
n = n-26^j;
else
Ninv(j) = alphabets(mod(n,26^j)/26^(j-1));
n = n-mod(n,26^(j));
end
end
end
i = i+1;
end
N = Ninv(i-1:-1:1);
elseif ischar(n) == 1 && sum(isletter(n)) == size(n,2)
n = upper(n);
for k = 1:size(n,2)
Na(k) = find(alphabets==n(k));
N = polyval(Na,26);
end
end


% Copyright (c) 2020, Daniel YC Lin
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 
% * Redistributions of source code must retain the above copyright notice, this
%   list of conditions and the following disclaimer.
% 
% * Redistributions in binary form must reproduce the above copyright notice,
%   this list of conditions and the following disclaimer in the documentation
%   and/or other materials provided with the distribution
% * Neither the name of National Cheng Kung University nor the names of its
%   contributors may be used to endorse or promote products derived from this
%   software without specific prior written permission.
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
