import time
# import datetime
from bot import Bot
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

class HealthBot:
    def __init__(this):
        # KIFlxrN08A9DYlJ0CYBm
        # UdOgX3txaiZDl8SguwwJdxxJfpY2
        this.botId = "UdOgX3txaiZDl8SguwwJdxxJfpY2"
        this.botId = "KIFlxrN08A9DYlJ0CYBm"
        this.db = this.fb_init()
        this.chat_streams = []

    def fb_init(this, ):
        _ = firebase_admin.initialize_app(credentials.Certificate('./ServiceAccountKey.json'))
        return firestore.client()

    def clear_chat_stream(this):
        for stream in this.chat_streams:
            stream.unsubscribe()
        this.chat_streams = []

    def reply_to_chat(this, chatId, text):
        data = {
            "text": text,
            "createdBy": this.botId,
            "createdAt": firestore.SERVER_TIMESTAMP,
        }
        print("reply:", data["text"])
        this.db.collection("chats").document(chatId).collection("msgs").add(data)

    def stream_chat(this, doc_snapshot, changes, read_time, chatId):
        for doc in doc_snapshot:
            if not doc.exists:
                continue
            msg = doc.to_dict()
            if msg["createdBy"] == this.botId:
                continue
            # bot = Bot()
            # ans = bot.ask(msg["text"])
            print("qsn", msg["text"], )
            ans = msg["text"] + " ko--"
            this.reply_to_chat(chatId, ans)

    def stream_chats(this, chatIds):
        this.clear_chat_stream()
        for chatId in chatIds:
            chat_ref = this.db.collection('chats').document(chatId)
            # chat_stream = chat_ref.collection('msgs').order_by("createdAt").limit_to_last(1).on_snapshot(this.stream_chat)
            chat_stream = chat_ref.collection('msgs').order_by("createdAt", direction=firestore.Query.DESCENDING).limit(1) \
                .on_snapshot(lambda doc_snapshot, changes, read_time: this.stream_chat(doc_snapshot, changes, read_time, chatId))
            this.chat_streams.append(chat_stream)

    def update_chat_ids(this, doc_snapshot, changes, read_time):
        chatIds = []
        for doc in doc_snapshot:
            chatIds.append(doc.id)
            # print('doc:', doc.id)
        # print('stream update', chatIds)
        chatIds = list(set(chatIds))
        this.stream_chats(chatIds)

    def start_streams(this):
        # where participans have botid
        # _ = db.collection('chats').on_snapshot(update_chat_ids) #.where("uid","==","KIFlxrN08A9DYlJ0CYBm")
        # _ = db.collection('chats').where("participants", "array_contains", "KIFlxrN08A9DYlJ0CYBm").on_snapshot(update_chat_ids)
        _ = this.db.collection('chats').where("participants", "array_contains", this.botId).on_snapshot(this.update_chat_ids)


if __name__ == "__main__":
    hbot = HealthBot()
    hbot.start_streams()

while True:
    time.sleep(1)