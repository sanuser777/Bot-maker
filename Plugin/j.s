const { izumi, mode } = require("../lib");
const yts = require("yt-search");
const fetch = require("node-fetch");

izumi({
  pattern: "song ?(.*)",
  fromMe: mode,
  desc: "Search and download audio from YouTube.",
  type: "downloader",
}, async (message, match, client) => {
  if (!match) {
    return await message.reply("Please provide a search query or YouTube URL.");
  }

  try {
    const { videos } = await yts(match);
    const firstVideo = videos[0];
    const url = firstVideo.url;
    const api = `https://api.siputzx.my.id/api/d/ytmp4?url=${url}`;

    const response = await fetch(api);
    const result = await response.json();
    const data = result.data;
    const dl = data.dl;
    const title = data.title;

    await message.reply(`_Downloading ${title}_`);
    await client.sendMessage(message.jid, {
      audio: { url: dl },
      caption: title,
      mimetype: "audio/mpeg",
    }, { quoted: message.data });
  } catch (error) {
    console.error("Error:", error);
    await message.reply("An error occurred while processing your request. Please try again later.");
  }
  });
});
