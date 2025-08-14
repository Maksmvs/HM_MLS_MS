import torch
import torchvision.models as models

model = models.mobilenet_v2(pretrained=True)
model.eval()

scripted_model = torch.jit.script(model)
scripted_model.save("model.pt")

print("Модель збережена у model.pt")
