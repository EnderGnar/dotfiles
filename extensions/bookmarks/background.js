let tree;

chrome.omnibox.onInputStarted.addListener(async () => {
    tree = (await chrome.bookmarks.getTree())[0];
})

chrome.omnibox.onInputChanged.addListener(async (text, suggest) => {
    const suggestions = await create_suggestions(text);
    suggest(suggestions);
});


async function create_suggestions(text) {
    if(!tree) tree = (await chrome.bookmarks.getTree())[0];

    let list = fold(tree, "");

    const regex = new RegExp("/"+text, "i");

    let options = list.filter(({path}) => path.match(regex));
    
    let suggestions = await Promise.all(options.map(async ({path, id}) => {
        let {url} = (await chrome.bookmarks.get(id))[0];
        return {deletable: false, content: url, description: path}
    }));

    return suggestions.slice(0,5);
}

function fold(tree, acc){
    let list = [];

    if (tree.children) for(let child of tree.children) {
        list.push(...fold(child, acc+tree.title+"/"));
    }
    else {
        list.push({path: acc+tree.title, id: tree.id});
    }

    return list;
}

chrome.omnibox.onInputEntered.addListener(async (content) => {
    let tab = await chrome.tabs.getCurrent();
    chrome.tabs.update(tab, {url:content});
});

