## senna-wordvec

The word embedding vectors from Senna[1]. Senna's lua wrapper can be fount at [2]. This project is inspired by [3].
Note: Senna's words are all in lower case. Any number is replaced with 0.

### Prerequisites
* Torch 7
* Senna (see [1])

### Installation
* run command ```git clone https://github.com/pengsun/senna-wordvec-torch```
* cd to the directory.
  * open `init.lua`
  * modify the two variables `opt.pathSennaWord` and `opt.pathSennaVec` to the corresponding files in your local machine.
  * modify the `opt.pathMyt7`, where the t7 file will be saved, to the path you like 
* run command ```luarocks make```

Then the lib will ba installed to your torch 7 directory. Delete the source directory if you like.

### Usage
#### [FloatTensor] word2vec(self,word)
Takes as input a word in lua string, return the corresponding word vector. return `nil` if the word is out of vocabulary.

#### [number] vec_size(self)
The embedded word vector size. Should be 50.

#### [string] __tostring__(self)
to string.

#### member variable `vocab`
The word vocabulary. a lua table

#### member variable `vecs`
The word vectors. 

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