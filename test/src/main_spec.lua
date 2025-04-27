local internal = require("bloat.internal")

describe("bloat", function()
  it("generate_analysis", function()
    local file_path = vim.fn.tempname()
    internal.generate_analysis(file_path, { "test/resources/sample" })

    local file = assert(io.open(file_path, "r"))
    local data = vim.fn.json_decode(file:read("*all"))
    file:close()

    assert.same({
      inputs = {
        ["test/resources/sample/lua/a.lua"] = {
          bytes = 12,
          imports = {}
        },
        ["test/resources/sample/lua/b.lua"] = {
          bytes = 15,
          imports = {}
        },
        ["test/resources/sample/plugin/c.vim"] = {
          bytes = 10,
          imports = {}
        },
      },
      outputs = {
        root = {
          bytes = 37,
          exports = {},
          imports = {},
          inputs = {
            ["test/resources/sample/lua/a.lua"] = {
              bytesInOutput = 12
            },
            ["test/resources/sample/lua/b.lua"] = {
              bytesInOutput = 15
            },
            ["test/resources/sample/plugin/c.vim"] = {
              bytesInOutput = 10
            },
          }
        }
      }
    }, data)
  end)
end)
