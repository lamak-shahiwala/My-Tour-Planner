# # With budget type
# from flask import Flask, request, jsonify
# from supabase_config import supabase
#
# app = Flask(__name__)
#
# @app.route('/recommend', methods=['POST'])
# def recommend():
#     try:
#         data = request.get_json()
#         user_id = data.get('user_id')
#
#         if not user_id:
#             return jsonify({"error": "Missing User ID"}), 400
#
#         # 1. Get preferences
#         pref_response = supabase.table('Preferences').select('*').eq('user_id', user_id).execute()
#         if not pref_response.data:
#             return jsonify({"error": "Preferences not found"}), 404
#
#         preferences = pref_response.data[0]
#         trip_type_pref = preferences.get('trip_type_preference', [])
#         budget_pref = preferences.get('budget_preference', '').lower()
#
#         # Ensure trip_type_pref is a list
#         if isinstance(trip_type_pref, str):
#             trip_type_pref = [trip_type_pref]
#
#         # 2. Get trips and templates
#         trip_response = supabase.table('Trip').select('*').execute()
#         template_response = supabase.table('Template').select('template_id, trip_id').execute()
#
#         trip_to_template = {tpl['trip_id']: tpl['template_id'] for tpl in template_response.data}
#         recommended = []
#
#         for trip in trip_response.data:
#             if (
#                     trip.get('trip_type') in trip_type_pref and
#                     trip.get('trip_budget', '').lower() == budget_pref
#             ):
#                 trip['template_id'] = trip_to_template.get(trip['trip_id'])
#                 recommended.append(trip)
#
#         return jsonify({"Recommended Trips": recommended}), 200
#
#     except Exception as e:
#         import traceback
#         print(" ERROR:", e)
#         traceback.print_exc()
#         return jsonify({"error": str(e)}), 500
#
#
#
# if __name__ == '__main__':
#     app.run(debug=True)

# Without budget
from flask import Flask, request, jsonify
from supabase_config import supabase

app = Flask(__name__)

@app.route('/recommend', methods=['POST'])
def recommend():
    try:
        data = request.get_json()
        user_id = data.get('user_id')

        if not user_id:
            return jsonify({"error": "Missing User ID"}), 400

        # 1. Get preferences (only trip type)
        pref_response = supabase.table('Preferences').select('trip_type_preference').eq('user_id', user_id).execute()
        if not pref_response.data:
            return jsonify({"error": "Preferences not found"}), 404

        preferences = pref_response.data[0]
        trip_type_pref = preferences.get('trip_type_preference', [])

        # Ensure trip_type_pref is a list
        if isinstance(trip_type_pref, str):
            trip_type_pref = [trip_type_pref]

        # 2. Get trips and templates
        trip_response = supabase.table('Trip').select('trip_id, trip_name, cover_photo_url, city_location, trip_type').execute()
        template_response = supabase.table('Template').select('template_id, trip_id').execute()

        trip_to_template = {tpl['trip_id']: tpl['template_id'] for tpl in template_response.data}
        recommended = []

        for trip in trip_response.data:
            if trip.get('trip_type') in trip_type_pref:
                trip['template_id'] = trip_to_template.get(trip['trip_id'])
                recommended.append(trip)

        return jsonify({"Recommended Trips": recommended}), 200

    except Exception as e:
        import traceback
        print(" ERROR:", e)
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)