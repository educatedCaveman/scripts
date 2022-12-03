import discord
from discord.ext import commands
import requests
import datetime
import os

TOKEN = ''


def capture_snapshot():
    URL = "http://192.168.11.10:8081/?action=snapshot"
    snapshot = f"/tmp/snapshot_{datetime.datetime.now().strftime('%F-%T')}.jpeg"
    print(f'capturing snapshot: {snapshot}')
    response = requests.get(URL)
    open(snapshot, 'wb').write(response.content)

    return snapshot

bot_intents = discord.Intents.default()
bot_intents.message_content = True
bot = commands.Bot(command_prefix='!', intents=bot_intents)

@bot.command(name='snapshot')
async def snapshot(context):
    snapshot = capture_snapshot()
    embed = discord.Embed()
    base_name = snapshot.split('/')[-1]
    file = discord.File(snapshot, filename=base_name)
    embed.set_image(url=f"attachment://{base_name}")
    await context.send(content="current snapshot:", file=file)


@bot.command(name='snapshit')
async def snapshit(context):
    await snapshot(context)
    await context.send(content="BTW, you should use !snapshot, not !snapshit.")


@bot.command(name='mooraker_snapshot')
async def snapshit(context):
    await snapshot(context)
    # await context.send(content="BTW, you should use !snapshot, not !snapshit.")


# this is a bad way to do this, but i can't figure out how to get this bot
# to listen to !commmands from other bots.
@bot.event
async def on_message(message):
    ctx = await bot.get_context(message)
    await bot.invoke(ctx)
    if message.channel.name == '3d_printing' \
            and message.author.bot \
            and 'Your printer completed printing' in message.content:
        await snapshot(ctx)

bot.run(TOKEN)
# client.run(TOKEN)