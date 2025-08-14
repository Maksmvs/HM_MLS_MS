import torch
from PIL import Image
import torchvision.transforms as transforms
import json
import sys

model = torch.jit.load("model.pt")
model.eval()

transform = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406],
                         [0.229, 0.224, 0.225])
])

with open("imagenet_classes.json") as f:
    labels = json.load(f)

if len(sys.argv) < 2:
    print("Вкажіть шлях до зображення!")
    sys.exit(1)

img_path = sys.argv[1]
img = Image.open(img_path).convert("RGB")
img_t = transform(img).unsqueeze(0)

with torch.no_grad():
    outputs = model(img_t)
    _, indices = outputs.topk(3)
    probs = torch.nn.functional.softmax(outputs[0], dim=0)

for idx in indices[0]:
    print(f"{labels[idx]}: {probs[idx].item()*100:.2f}%")
