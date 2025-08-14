import torch
import torchvision.models as models
import json
import urllib.request


model = models.mobilenet_v2(weights=models.MobileNet_V2_Weights.DEFAULT)  # новий синтаксис
model.eval()

scripted_model = torch.jit.script(model)
scripted_model.save("model.pt")
print("[OK] Модель збережена у model.pt")



url = "https://raw.githubusercontent.com/pytorch/hub/master/imagenet_classes.txt"
urllib.request.urlretrieve(url, "imagenet_classes.txt")

with open("imagenet_classes.txt", "r") as f:
    classes = [line.strip() for line in f]

with open("imagenet_classes.json", "w") as f:
    json.dump(classes, f)

print("[OK] imagenet_classes.json збережено у поточній папці")
