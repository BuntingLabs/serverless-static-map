import sys
from pymgl import Map
import base64
import json
from io import BytesIO
from PIL import Image

style = """{
    "version": 8,
    "sources": {
        "basemap": {
            "type": "raster",
            "tiles": ["https://services.arcgisonline.com/arcgis/rest/services/Ocean/World_Ocean_Base/MapServer/tile/{z}/{y}/{x}"],
            "tileSize": 256
        }
    },
    "layers": [
        { "id": "basemap", "source": "basemap", "type": "raster" }
    ]
}"""

def handler(event, context):
    img_shape = (512, 512)

    basemap = Map(style, width=img_shape[0], height=img_shape[1], longitude=0.1276, latitude=51.6072,
        zoom=11)# <token=None>, <provider=None>)

    buf = basemap.renderBuffer()

    img = Image.frombytes("RGBA", img_shape, buf)
    img_bytes = BytesIO()
    img.save(img_bytes, format="PNG")
    img_bytes.seek(0)

    base64_image = base64.b64encode(img_bytes.getvalue()).decode()

    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'image/png',
            'Content-Disposition': f'attachment; filename="map.png"'
        },
        'isBase64Encoded': True,
        'body': base64_image
    }
    
