## senna-wordvec

The word embedding vectors from Senna[1]. Senna's lua wrapper can be fount at [2]. This project is inspired by [3].
Note: Senna's words are all in lower case. Any number is replaced with 0.

### Prerequisites
* Torch 7
* Senna (see [1]). Needs not be compiled, just the data files that come with Senna are needed, see below.

### Installation
* run command ```git clone https://github.com/pengsun/senna-wordvec-torch```
* cd to the directory.
  * open `init.lua`
  * modify the two variables `opt.pathSennaWord` and `opt.pathSennaVec` to the corresponding Senna files in your local machine.
  * modify the variable `opt.pathMyt7`, where the pre-saved t7 file will be put, to the path you like 
* run command ```luarocks make```

Then the lib will ba installed to your torch 7 directory. Delete the git-cloned source directory `senna-wordvec-torch` if you like.

### Usage
#### [FloatTensor] word2vec(self, word)
Takes as input a word in lua string, return the corresponding word vector. return `nil` if the word is out of vocabulary.

#### [number] vec_size(self)
The embedded word vector size. Should be 50.

#### [string] __tostring__(self)
to string.

#### member variable `vocab`
A lua table, the word vocabulary.

#### member variable `vecs`
A `torch.FloatTensor`, the word vectors. 

###Examples

```Lua

    local swe = require 'senna-wordvec'
    print(swe)
    
    v1 = swe:word2vec('hello')
    v2 = swe:word2vec('world')
    
    v3 = swe:word2vec('ps0') -- note: senna replace any number with 0, so `ps2` should be fed as `ps0`
    v4 = swe:word2vec('0-year-old')
     
    assert(nil == swe:word2vec('nosuchword')) 
     
    assert(swe:vec_size()==50)

```

###Reference
[1] http://ml.nec-labs.com/senna/

[2] https://github.com/torch/senna

[3] https://github.com/rotmanmi/word2vec.torch
