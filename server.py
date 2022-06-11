import asyncio
import random
from websockets import serve


class Room:
    def __init__(self, p1):
        self.p1 = p1
        self.p2 = None


rooms = []


async def handler(websocket):
    message = await websocket.recv()
    print(message)
    if(message == "Hello"):
        if len(rooms) == 0:
            room = Room(websocket)
            rooms.append(room)
            await echo(room, "p1")
        else:
            print("Room full")
            room = rooms[0]
            room.p2 = websocket
            rooms.pop(0)
            await websocket.send("Connected")
            await echo(room, "p2")


async def echo(room, player):
    while True:
        if(player == "p1"):
            message = await room.p1.recv()
            if(room.p2):
                await room.p2.send(message)
        else:
            message = await room.p2.recv()
            await room.p1.send(message)


async def main():

    async with serve(handler, "0.0.0.0", 3000):
        # print server ip address and port
        await asyncio.Future()  # run forever

asyncio.run(main())
