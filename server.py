from flask import Flask, jsonify, request
from flask_cors import CORS
import pyodbc

app = Flask(__name__)
CORS(app)

db_config = {
    'server': 'localhost\\SQLEXPRESS',
    'database': 'GiaPhaHoNguyen',
    'username': 'sa',
    'password': '123456'  # Đổi thành mật khẩu SQL Server của mày
}

def get_db_connection():
    conn_str = (
        'DRIVER={ODBC Driver 17 for SQL Server};'
        f"SERVER={db_config['server']};"
        f"DATABASE={db_config['database']};"
        f"UID={db_config['username']};"
        f"PWD={db_config['password']}"
    )
    return pyodbc.connect(conn_str)

# 1. API Lấy danh sách toàn bộ thành viên
@app.route('/api/thanh-vien', methods=['GET'])
def get_thanh_vien():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        query = """
            SELECT 
                tv.id, tv.ho_ten, tv.gioi_tinh, 
                YEAR(tv.ngay_sinh) AS nam_sinh, 
                tv.the_he_id AS doi_thu,
                cha.ho_ten AS ten_cha,
                qh.cha_id
            FROM ThanhVien tv
            LEFT JOIN QuanHeChaCon qh ON tv.id = qh.con_id
            LEFT JOIN ThanhVien cha ON qh.cha_id = cha.id
            ORDER BY tv.the_he_id ASC, tv.id ASC
        """
        cursor.execute(query)
        rows = cursor.fetchall()
        
        result = []
        for row in rows:
            result.append({
                "id": row.id,
                "ho_ten": row.ho_ten,
                "gioi_tinh": row.gioi_tinh,
                "nam_sinh": row.nam_sinh,
                "doi_thu": f"ĐỜI {row.doi_thu}",
                "ten_cha": row.ten_cha if row.ten_cha else "Không có (Thủy Tổ)",
                "cha_id": row.cha_id
            })
        conn.close()
        return jsonify({"success": True, "data": result})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500

# 2. API Thêm thành viên mới
@app.route('/api/thanh-vien', methods=['POST'])
def add_thanh_vien():
    try:
        data = request.json
        ho_ten = data.get('ho_ten')
        gioi_tinh = data.get('gioi_tinh')
        nam_sinh = data.get('nam_sinh')
        cha_id = data.get('cha_id')

        conn = get_db_connection()
        cursor = conn.cursor()

        doi_thu = 1
        if cha_id:
            cursor.execute("SELECT the_he_id FROM ThanhVien WHERE id = ?", cha_id)
            parent = cursor.fetchone()
            if parent:
                doi_thu = parent.the_he_id + 1

        ngay_sinh = f"{nam_sinh}-01-01" if nam_sinh else '2000-01-01'
        cursor.execute("""
            INSERT INTO ThanhVien (ho_ten, gioi_tinh, ngay_sinh, trang_thai, dong_ho_id, the_he_id)
            OUTPUT INSERTED.id
            VALUES (?, ?, ?, N'Còn sống', 1, ?)
        """, (ho_ten, gioi_tinh, ngay_sinh, doi_thu))
        
        new_id = cursor.fetchone()[0]

        if cha_id:
            cursor.execute("INSERT INTO QuanHeChaCon (cha_id, con_id) VALUES (?, ?)", (cha_id, new_id))

        conn.commit()
        conn.close()
        return jsonify({"success": True, "message": "Thêm thành công!"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500

# 3. API Phân tích quan hệ họ hàng (Tìm tổ tiên, con cháu, anh chị em)
@app.route('/api/tra-cuu/<int:id>', methods=['GET'])
def tra_cuu_quan_he(id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Tìm Tổ Tiên (Cha/Ông...)
        cursor.execute("""
            SELECT t2.id, t2.ho_ten, t2.the_he_id 
            FROM QuanHeChaCon qh 
            JOIN ThanhVien t2 ON qh.cha_id = t2.id 
            WHERE qh.con_id = ?
        """, id)
        to_tien = [{"id": r.id, "ho_ten": r.ho_ten, "doi": r.the_he_id} for r in cursor.fetchall()]

        # Tìm Con Cháu trực hệ
        cursor.execute("""
            SELECT t2.id, t2.ho_ten, t2.the_he_id 
            FROM QuanHeChaCon qh 
            JOIN ThanhVien t2 ON qh.con_id = t2.id 
            WHERE qh.cha_id = ?
        """, id)
        con_chau = [{"id": r.id, "ho_ten": r.ho_ten, "doi": r.the_he_id} for r in cursor.fetchall()]

        # Tìm Anh Chị Em ruột (chung cha)
        cursor.execute("""
            SELECT t2.id, t2.ho_ten, t2.the_he_id 
            FROM QuanHeChaCon qh1
            JOIN QuanHeChaCon qh2 ON qh1.cha_id = qh2.cha_id
            JOIN ThanhVien t2 ON qh2.con_id = t2.id
            WHERE qh1.con_id = ? AND t2.id <> ?
        """, (id, id))
        anh_em = [{"id": r.id, "ho_ten": r.ho_ten, "doi": r.the_he_id} for r in cursor.fetchall()]

        conn.close()
        return jsonify({
            "success": True,
            "to_tien": to_tien,
            "con_chau": con_chau,
            "anh_em": anh_em
        })
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)
    