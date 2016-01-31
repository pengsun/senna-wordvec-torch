require'torch'
xlua = require'xlua'
path = require'pl.path'
file = require'pl.file'

--- Global options. Modify it to your own environment.
local opt = {
    pathSennaWord = '/home/ps/data/senna/hash/words.lst',
    pathSennaVec = '/home/ps/data/senna/embeddings/embeddings.txt',

    pathMyt7 = '/home/ps/data/senna/embeddings/swe.t7',
}


--- Helper
local myName = 'senna-wordvec-torch'

local VEC_SIZE = 50

local function assert_file(fn)
    if not path.isfile(fn) then
        error(myName .. ': cannot find ' .. fn)
    end
end

local function load_vocab(fn)
    assert_file(fn)

    local vocab, count = {}, 0
    local lines = stringx.splitlines( file.read(fn) )
    for _, word in pairs(lines) do
        if not vocab[word] then -- insert new word
        count = count + 1
        vocab[word] = count
        end
    end

    return vocab
end

local function load_vecs(fn)
    assert_file(fn)

    local lines = stringx.splitlines( file.read(fn) )
    local vecs = torch.FloatTensor(#lines, VEC_SIZE)
    for i, line in ipairs(lines) do
        -- the vector as string
        local v = stringx.split(line, ' ')

        -- the vector as number table
        for k in ipairs(v) do
            v[k] = tonumber(v[k])
            assert(v[k], "conversion failed. line " .. i .. ", k " .. k)
        end

        -- fill the vecs
        vecs[i]:copy( torch.FloatTensor(v) )

        xlua.progress(i, #lines)
    end

    return vecs
end


--- The Class to be exposed. A simple wrapper
do
    local SennaWordEmbedding = torch.class('SennaWordEmbedding')

    function SennaWordEmbedding:__init(opt)
        self.vocab = load_vocab(opt.pathSennaWord)
        self.vecs = load_vecs(opt.pathSennaVec)

        assert(tablex.size(self.vocab) == self.vecs:size(1),
            "#words of loaded vocabulary ~= #words of loaded vectors!"
        )
        assert(self:vec_size() == self.vecs:size(2),
            "loaded vector size ~= " .. self.vecs:size(2)
        )
    end

    function SennaWordEmbedding:word2vec(word)
        local idx = self.vocab[word]

        if idx then
            return self.vecs[idx]:clone()
        end
        -- else: return nil
    end

    function SennaWordEmbedding:vec_size()
        return VEC_SIZE
    end

    function SennaWordEmbedding:__tostring__()
        local str = ""
        str = str .. myName .. ": " .. "\n"
        str = str .. '#words = ' .. tablex.size(self.vocab) .. "\n"
        str = str .. '#vec size = ' .. self:vec_size() .. "\n"
        return str
    end
end

--- main
local function main(opt)
    local swe -- the wrapper to be returned
    --require'mobdebug'.start()
    if not path.isfile(opt.pathMyt7) then -- generating t7 file
        print(myName .. ': reading Senna word list and embedding vecotrs from ')
        print(opt.pathSennaWord)
        print(opt.pathSennaVec)
        swe = SennaWordEmbedding(opt)

        print(myName .. ': saving t7 file to ')
        print(opt.pathMyt7)
        torch.save(opt.pathMyt7, swe)
    else -- load from pre-saved t7 file
        print(myName .. ': reading pre-saved t7 file from')
        print(opt.pathMyt7)
        swe = torch.load(opt.pathMyt7)
    end

    return swe
end

return main(opt)