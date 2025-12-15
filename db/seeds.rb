# Тестові товари для каталогу (стрітвеар як на референсі)
Product.create!([
                  { name: 'T-Shirt Trippie', price: 25.00, description: 'Стильна футболка з принтом', category: 'Tops', stock: 5, image: 'https://via.placeholder.com/300x200?text=T-Shirt' },
                  { name: 'Scarf Gluck', price: 15.00, description: 'Шарф-аксесуар', category: 'Accessories', stock: 0, image: 'https://via.placeholder.com/300x200?text=Scarf' },  # Sold out
                  { name: 'Urban Bag', price: 40.00, description: 'Сумка для міста', category: 'Bags', stock: 12, image: 'https://via.placeholder.com/300x200?text=Bag' }
                ])