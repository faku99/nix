if vim.g.vscode then
    return {}
else
    return {
        { import = 'plugins.formatter' },
        { import = 'plugins.multicursors' },
        { import = 'plugins.neo-tree' },
        { import = 'plugins.neogen' },
        { import = 'plugins.todo-comments' },
    }
end
