# 📋 Cambios Realizados - QR con Referencia del Equipo

## 🎯 Objetivo
Agregar la referencia del equipo en la impresión de códigos QR, justo debajo de la placa y arriba del tipo de vehículo.

## ✅ Cambios Implementados

### 1. **Template de QR (`templates/qr_equipos/index.html`)**
- ✅ Agregado campo `data-referencia` al botón de impresión
- ✅ Modificada función JavaScript `imprimirQR()` para incluir referencia
- ✅ Actualizado HTML de impresión para mostrar referencia
- ✅ Agregados estilos CSS para `.equipo-referencia`

### 2. **Estructura de Impresión**
```
┌─────────────────────────┐
│    GRÚAS CRANES S.A.S   │
│                         │
│        PMR799           │  ← Placa (verde, 24px)
│        BRONCO           │  ← Referencia (azul, 18px) ✨ NUEVO
│      CAMIONETA          │  ← Tipo (gris, 16px)
│                         │
│    [CÓDIGO QR]          │
│                         │
│  Instrucciones:         │
│  Escanea este código... │
└─────────────────────────┘
```

### 3. **Scripts Creados**
- ✅ `regenerar_qr_con_referencia.py` - Regenera todos los QR
- ✅ `sync_qr_produccion.sh` - Sincroniza QR con producción
- ✅ `test_qr_print.html` - Archivo de prueba

## 🔧 Funcionalidad

### **Datos Mostrados en Impresión:**
1. **Placa del Equipo** - Verde, 24px, negrita
2. **Referencia del Equipo** - Azul, 18px, semi-negrita ✨ **NUEVO**
3. **Tipo de Vehículo** - Gris, 16px

### **Equipos con Referencia:**
- PMR799 → BRONCO
- POZ887 → FUSO  
- POZ873 → ACTROS
- MI725248 → DEMAG CHALLENGER 3160
- MI753619 → DEMAG EXPLORER
- MIC15635 → LTM1070-4.2
- MI045782 → LTM1080/1
- MI112324 → GMK3050
- NUU605 → DAF- XCT55_E
- NUV626 → FOTÓN-XCT55_E
- MI640780 → LTM1100
- MI698975 → AC 170

## 🚀 Cómo Usar

### **1. Acceder a QR Equipos:**
```
https://gestor.gruascranes.com/qr-equipos
```

### **2. Imprimir QR:**
- Hacer clic en "Imprimir QR" en cualquier equipo
- La ventana de impresión mostrará:
  - Logo de la empresa
  - Placa del equipo
  - **Referencia del equipo** ✨
  - Tipo de vehículo
  - Código QR
  - Instrucciones

### **3. Regenerar QR (si es necesario):**
```bash
cd /home/mauricio/apps/flask_app
source venv/bin/activate
python regenerar_qr_con_referencia.py
```

### **4. Sincronizar con Producción:**
```bash
./sync_qr_produccion.sh
```

## 📊 Resultado

Los códigos QR ahora muestran la información completa del equipo:
- **Placa**: Identificación principal
- **Referencia**: Modelo o nombre del equipo ✨
- **Tipo**: Categoría del vehículo

Esto facilita la identificación visual del equipo en el campo, especialmente cuando hay múltiples equipos del mismo tipo pero con diferentes referencias.

## 🎨 Estilos Aplicados

```css
.equipo-placa {
    font-size: 24px;
    font-weight: bold;
    color: #2e7d32;  /* Verde */
    margin-bottom: 5px;
}

.equipo-referencia {
    font-size: 18px;
    font-weight: 600;
    color: #1976d2;  /* Azul */
    margin-bottom: 5px;
}

.equipo-tipo {
    font-size: 16px;
    color: #666;     /* Gris */
    margin-bottom: 0;
}
```

## ✅ Estado
- ✅ Cambios implementados
- ✅ QR regenerados
- ✅ Funcionalidad probada
- ⏳ Pendiente: Sincronización con producción (requiere sudo)
