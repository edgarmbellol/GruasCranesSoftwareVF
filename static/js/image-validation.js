/**
 * Validación de tamaño de imágenes en el cliente
 * Previene el error 413 Request Entity Too Large
 */

function validateImageSize(input, maxSizeMB = 5) {
    const file = input.files[0];
    
    if (file) {
        const fileSizeMB = file.size / (1024 * 1024); // Convertir a MB
        
        if (fileSizeMB > maxSizeMB) {
            // Mostrar mensaje de error
            showImageSizeError(input, maxSizeMB);
            
            // Limpiar el input
            input.value = '';
            
            return false;
        } else {
            // Limpiar mensajes de error previos
            clearImageSizeError(input);
            
            // Mostrar información del archivo
            showImageInfo(input, fileSizeMB);
            
            return true;
        }
    }
    
    return true;
}

function showImageSizeError(input, maxSizeMB) {
    // Remover mensajes de error previos
    clearImageSizeError(input);
    
    // Crear mensaje de error
    const errorDiv = document.createElement('div');
    errorDiv.className = 'image-size-error text-danger mt-1';
    errorDiv.innerHTML = `
        <small>
            <i class="fas fa-exclamation-triangle"></i>
            El archivo es demasiado grande. Tamaño máximo permitido: ${maxSizeMB}MB
        </small>
    `;
    
    // Insertar después del input
    input.parentNode.insertBefore(errorDiv, input.nextSibling);
    
    // Agregar clase de error al input
    input.classList.add('is-invalid');
}

function clearImageSizeError(input) {
    // Remover mensajes de error
    const errorDiv = input.parentNode.querySelector('.image-size-error');
    if (errorDiv) {
        errorDiv.remove();
    }
    
    // Remover clase de error
    input.classList.remove('is-invalid');
    
    // Remover información del archivo
    const infoDiv = input.parentNode.querySelector('.image-size-info');
    if (infoDiv) {
        infoDiv.remove();
    }
}

function showImageInfo(input, fileSizeMB) {
    // Remover información previa
    const infoDiv = input.parentNode.querySelector('.image-size-info');
    if (infoDiv) {
        infoDiv.remove();
    }
    
    // Crear información del archivo
    const infoDivNew = document.createElement('div');
    infoDivNew.className = 'image-size-info text-success mt-1';
    infoDivNew.innerHTML = `
        <small>
            <i class="fas fa-check-circle"></i>
            Archivo válido (${fileSizeMB.toFixed(2)}MB)
        </small>
    `;
    
    // Insertar después del input
    input.parentNode.insertBefore(infoDivNew, input.nextSibling);
}

// Validación adicional para formularios con múltiples archivos
function validateAllImages(formId) {
    const form = document.getElementById(formId);
    if (!form) return true;
    
    const fileInputs = form.querySelectorAll('input[type="file"][accept*="image"]');
    let allValid = true;
    
    fileInputs.forEach(input => {
        if (!validateImageSize(input, 5)) {
            allValid = false;
        }
    });
    
    return allValid;
}

// Prevenir envío de formulario si hay archivos muy grandes
document.addEventListener('DOMContentLoaded', function() {
    const forms = document.querySelectorAll('form');
    
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            const fileInputs = form.querySelectorAll('input[type="file"][accept*="image"]');
            let hasErrors = false;
            
            fileInputs.forEach(input => {
                const file = input.files[0];
                if (file && file.size > 5 * 1024 * 1024) { // 5MB
                    showImageSizeError(input, 5);
                    hasErrors = true;
                }
            });
            
            if (hasErrors) {
                e.preventDefault();
                
                // Mostrar mensaje general
                showGeneralError('Por favor, reduce el tamaño de las imágenes antes de enviar el formulario.');
                
                // Scroll al primer error
                const firstError = form.querySelector('.is-invalid');
                if (firstError) {
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            }
        });
    });
});

function showGeneralError(message) {
    // Crear o actualizar mensaje de error general
    let errorDiv = document.getElementById('general-error-message');
    
    if (!errorDiv) {
        errorDiv = document.createElement('div');
        errorDiv.id = 'general-error-message';
        errorDiv.className = 'alert alert-danger alert-dismissible fade show mt-3';
        errorDiv.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        
        // Insertar al inicio del formulario
        const form = document.querySelector('form');
        if (form) {
            form.insertBefore(errorDiv, form.firstChild);
        }
    } else {
        errorDiv.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
    }
}

// Función para comprimir imágenes automáticamente
function compressImage(file, maxWidth = 1920, maxHeight = 1080, quality = 0.8) {
    return new Promise((resolve, reject) => {
        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');
        const img = new Image();
        
        img.onload = function() {
            try {
                // Calcular nuevas dimensiones manteniendo la proporción
                let { width, height } = img;
                
                if (width > maxWidth || height > maxHeight) {
                    const aspectRatio = width / height;
                    
                    if (width > height) {
                        width = Math.min(maxWidth, width);
                        height = width / aspectRatio;
                    } else {
                        height = Math.min(maxHeight, height);
                        width = height * aspectRatio;
                    }
                }
                
                canvas.width = width;
                canvas.height = height;
                
                // Configurar contexto para mejor calidad
                ctx.imageSmoothingEnabled = true;
                ctx.imageSmoothingQuality = 'high';
                
                // Dibujar imagen redimensionada
                ctx.drawImage(img, 0, 0, width, height);
                
                // Convertir a blob con compresión
                canvas.toBlob((blob) => {
                    if (blob) {
                        resolve(blob);
                    } else {
                        reject(new Error('Error al comprimir la imagen'));
                    }
                }, 'image/jpeg', quality);
                
            } catch (error) {
                reject(error);
            }
        };
        
        img.onerror = function() {
            reject(new Error('Error al cargar la imagen'));
        };
        
        img.src = URL.createObjectURL(file);
    });
}

// Función para comprimir automáticamente al seleccionar archivo
function autoCompressOnSelect(input, maxSizeMB = 5) {
    const file = input.files[0];
    
    if (file && file.type.startsWith('image/')) {
        const originalSizeMB = file.size / (1024 * 1024);
        
        // Si el archivo es mayor a 2MB, comprimir automáticamente
        if (originalSizeMB > 2) {
            showCompressionProgress(input);
            
            compressImage(file, 1920, 1080, 0.8)
                .then(compressedBlob => {
                    const compressedSizeMB = compressedBlob.size / (1024 * 1024);
                    
                    // Crear nuevo archivo con el blob comprimido
                    const compressedFile = new File([compressedBlob], file.name, {
                        type: 'image/jpeg',
                        lastModified: Date.now()
                    });
                    
                    // Reemplazar el archivo en el input
                    const dataTransfer = new DataTransfer();
                    dataTransfer.items.add(compressedFile);
                    input.files = dataTransfer.files;
                    
                    hideCompressionProgress(input);
                    showCompressionResult(input, originalSizeMB, compressedSizeMB);
                    
                    // Validar el tamaño final
                    validateImageSize(input, maxSizeMB);
                })
                .catch(error => {
                    hideCompressionProgress(input);
                    showCompressionError(input, error.message);
                });
        } else {
            // Archivo ya es pequeño, solo validar
            validateImageSize(input, maxSizeMB);
        }
    }
}

// Mostrar progreso de compresión
function showCompressionProgress(input) {
    clearImageSizeError(input);
    
    const progressDiv = document.createElement('div');
    progressDiv.className = 'image-compression-progress mt-2';
    progressDiv.innerHTML = `
        <div class="d-flex align-items-center">
            <div class="spinner-border spinner-border-sm text-primary me-2" role="status">
                <span class="visually-hidden">Comprimiendo...</span>
            </div>
            <small class="text-primary">Comprimiendo imagen...</small>
        </div>
    `;
    
    input.parentNode.insertBefore(progressDiv, input.nextSibling);
}

// Ocultar progreso de compresión
function hideCompressionProgress(input) {
    const progressDiv = input.parentNode.querySelector('.image-compression-progress');
    if (progressDiv) {
        progressDiv.remove();
    }
}

// Mostrar resultado de compresión
function showCompressionResult(input, originalSize, compressedSize) {
    const resultDiv = document.createElement('div');
    resultDiv.className = 'image-compression-result text-success mt-2';
    
    const savedPercent = Math.round(((originalSize - compressedSize) / originalSize) * 100);
    
    resultDiv.innerHTML = `
        <small>
            <i class="fas fa-check-circle"></i>
            Imagen comprimida: ${originalSize.toFixed(2)}MB → ${compressedSize.toFixed(2)}MB 
            <span class="badge bg-success ms-1">-${savedPercent}%</span>
        </small>
    `;
    
    input.parentNode.insertBefore(resultDiv, input.nextSibling);
}

// Mostrar error de compresión
function showCompressionError(input, errorMessage) {
    const errorDiv = document.createElement('div');
    errorDiv.className = 'image-compression-error text-danger mt-2';
    errorDiv.innerHTML = `
        <small>
            <i class="fas fa-exclamation-triangle"></i>
            Error al comprimir: ${errorMessage}
        </small>
    `;
    
    input.parentNode.insertBefore(errorDiv, input.nextSibling);
    input.classList.add('is-invalid');
}
